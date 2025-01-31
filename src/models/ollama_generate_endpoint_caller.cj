package ollama4cj.models

import std.time.DateTime
import net.http.ClientBuilder
import std.io.StringReader
import ollama4cj.exceptions.OllamaBaseException
import ollama4cj.utils.HttpUtils

public class OllamaGenerateEndpointCaller <: OllamaEndpointCaller {

    private var streamObserver: ?OllamaGenerateStreamObserver = None

    public OllamaGenerateEndpointCaller(host: String, basicAuth: ?BasicAuth, requestTimeoutSeconds: Int64) {
        super(host, basicAuth, requestTimeoutSeconds)
    }

    public override func getEndpointSuffix(): String {
        return "/api/generate"
    }

    public override func parseResponseAndAddToBuffer(line: String, responseBuffer: StringBuilder): Bool {
        try {
             let model = OllamaGenerateResponseModel.fromJson(line)
             responseBuffer.append(model.response)
            if (!streamObserver.isNone()) {
                streamObserver?.notify(model)
            }
            return model.done
        } catch (e: Exception) {
            return true
        }
    }

    public func call(body: OllamaGenerateRequest, streamHandler: ?OllamaStreamHandler): OllamaResult {
        streamObserver = OllamaGenerateStreamObserver(streamHandler)
        return callSync(body)
    }

    public func callSync(body: OllamaGenerateRequest): OllamaResult {
        let startTime = DateTime.now().toUnixTimeStamp().toMilliseconds()
        let url = host + getEndpointSuffix()
        let req = getRequestBuilderDefault(url).body(body.toJson()).post().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        if (statusCode == 200) {
            let model = OllamaGenerateResponseModel.fromJson(respBody)
            let endTime = DateTime.now().toUnixTimeStamp().toMilliseconds()
            return OllamaResult(response: model.response, responseTime: (endTime - startTime), httpStatusCode: Int64(statusCode))
        }
        if (statusCode == 404 || statusCode == 400) {
            let err = OllamaErrorResponse.fromJson(respBody)
            throw OllamaBaseException(err.error)
        } else if (statusCode == 401) {
            throw OllamaBaseException("Unauthorized")
        } else {
            throw OllamaBaseException("Exception with status: ${statusCode}")
        }

    }
}

