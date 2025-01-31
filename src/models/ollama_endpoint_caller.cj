package ollama4cj.models

import encoding.base64.toBase64String
import net.http.HttpRequestBuilder

public abstract class OllamaEndpointCaller {

    public OllamaEndpointCaller(
        public var host: String,
        public var basicAuth: ?BasicAuth,
        public var requestTimeoutSeconds: Int64
    ) {

    }

    protected func getEndpointSuffix(): String

    protected func parseResponseAndAddToBuffer(line: String, responseBuffer: StringBuilder): Bool


    protected func getBasicAuthHeaderValue(): String {
        let credentialsToEncode = (basicAuth?.username ?? "") + ":" + (basicAuth?.password ?? "")
        return "Basic " + toBase64String(credentialsToEncode.toArray())
    }

    protected func isBasicAuthCredentialsSet(): Bool {
        return !basicAuth.isNone()
    }

    protected func getRequestBuilderDefault(url: String): HttpRequestBuilder {
        
        let hb = HttpRequestBuilder().url(url).header("Content-Type", "application/json")
            .readTimeout(requestTimeoutSeconds * Duration.second).writeTimeout(requestTimeoutSeconds * Duration.second)
        if (isBasicAuthCredentialsSet()) {
            hb.header("Authorization", getBasicAuthHeaderValue())
        }
        return hb
    }
}
