package ollama4cj.models

import net.http.ClientBuilder
import std.io.StringReader
import ollama4cj.exceptions.OllamaBaseException
import ollama4cj.utils.HttpUtils

public class OllamaChatEndpointCaller <: OllamaEndpointCaller {

    private var tokenHandler: ?OllamaTokenHandler = None

    public OllamaChatEndpointCaller(host: String, basicAuth: ?BasicAuth, requestTimeoutSeconds: Int64) {
        super(host, basicAuth, requestTimeoutSeconds)
    }

    public override func getEndpointSuffix(): String {
        return "/api/chat"
    }

    public override func parseResponseAndAddToBuffer(line: String, responseBuffer: StringBuilder): Bool {
        try {
             let model = OllamaChatResponseModel.fromJson(line)
             let message = model.message
             if (!message.isNone()) {
                responseBuffer.append(message?.content ?? "")
                if (!tokenHandler.isNone()) {
                    tokenHandler?.accept(model)
                }
             }
             return model.done
        } catch (e: Exception) {
            return true
        }
    }

    public func call(body: OllamaChatRequest, tokenHandler: ?OllamaTokenHandler): OllamaChatResult {
        this.tokenHandler = tokenHandler
        return callSync(body)
    }

    public func callSync(body: OllamaChatRequest): OllamaChatResult {
        let url = host + getEndpointSuffix()
        let req = getRequestBuilderDefault(url).body(body.toJson()).post().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        
        if (statusCode == 200) {
            let model = OllamaChatResponseModel.fromJson(respBody)
            let history = body.messages
            return OllamaChatResult(responseModel: model, chatHistory: history)
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