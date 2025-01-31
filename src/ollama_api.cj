package  ollama4cj

import ollama4cj.models.BasicAuth
import std.collection.ArrayList
import ollama4cj.models.*
import ollama4cj.utils.Options
import std.fs.File
import ollama4cj.utils.Utils
import net.http.HttpRequestBuilder
import encoding.base64.toBase64String
import ollama4cj.exceptions.OllamaBaseException
import ollama4cj.utils.HttpUtils

public class OllamaAPI {

    var requestTimeoutSeconds = 60
    var maxChatToolCallRetries = 3
    var basicAuth: ?BasicAuth = None;

    public OllamaAPI(public var host!: String = "http://localhost:11434") {
    }

    public func setBasicAuth(username: String, password: String) {
        basicAuth = BasicAuth(username: username, password: password)
    }

    // listModels

    public func listModels(): ArrayList<Model> {
        let url = host + "/api/tags"
        let req = getRequestBuilderDefault(url).header("Accept", "application/json").get().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        if (statusCode == 200) {
            return ListModelsResponse.fromJson(respBody).models
        } else {
            throw OllamaBaseException("${statusCode} - ${respBody}")
        }
    }

    // pullModel
    public func pullModel(modelName: String) {
        let url = host + "/api/pull"
        let req = getRequestBuilderDefault(url).body(ModelRequest(modelName).toJson()).header("Accept", "application/json").post().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        if (statusCode != 200) {
            throw OllamaBaseException("${statusCode} - ${respBody}")
        }
    }

    // getModelDetails
    public func getModelDetails(modelName: String): ModelDetail {
        let url = host + "/api/show"
        let req = getRequestBuilderDefault(url).body(ModelRequest(modelName).toJson()).header("Accept", "application/json").post().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        if (statusCode == 200) {
            return ModelDetail.fromJson(respBody)
        } else {
            throw OllamaBaseException("${statusCode} - ${respBody}")
        }
    }

    // createModelWithFilePath
    public func createModelWithFilePath(modelName: String, modelFilePath: String) {
        let url = host + "/api/create"
        let req = getRequestBuilderDefault(url).body(CustomModelFilePathRequest(modelName, modelFilePath).toJson()).header("Accept", "application/json").post().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        if (statusCode != 200) {
            throw OllamaBaseException("${statusCode} - ${respBody}")
        }
        if (respBody.contains("error")) {
            throw OllamaBaseException(respBody)
        }
    }

    // createModelWithModelFileContents
    public func createModelWithModelFileContents(modelName: String, modelFileContents: String) {
        let url = host + "/api/create"
        let req = getRequestBuilderDefault(url).body(CustomModelFileContentsRequest(modelName, modelFileContents).toJson()).header("Accept", "application/json").post().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        if (statusCode != 200) {
            throw OllamaBaseException("${statusCode} - ${respBody}")
        }
        if (respBody.contains("error")) {
            throw OllamaBaseException(respBody)
        }
    }

    // deleteModel
    public func deleteModel(modelName: String) {
        let url = host + "/api/delete"
        let req = getRequestBuilderDefault(url).body(ModelRequest(modelName).toJson()).header("Accept", "application/json").delete().build()
        let (statusCode, respBody) = HttpUtils.call(req)
        if (statusCode == 404 && respBody.contains("model") && respBody.contains("not found")) {
            return
        }
        if (statusCode != 200) {
            throw OllamaBaseException("${statusCode} - ${respBody}")
        }
    }

        
    // addCustomRole
    public func addCustomRole(roleName: String): OllamaChatMessageRole {
        return OllamaChatMessageRole.newCustomRole(roleName)
    }

    // listRoles
    public func listRoles(): ArrayList<OllamaChatMessageRole> {
        return OllamaChatMessageRole.getRoles()
    }

    // generate
    public func generate(model: String, prompt: String, raw!: Bool = false, options!: Options = Options()): OllamaResult {
        let req = OllamaGenerateRequest(model: model, prompt: prompt)
        req.raw = raw
        req.options = options.optionsMap
        let caller = OllamaGenerateEndpointCaller(host, basicAuth, requestTimeoutSeconds)
        return caller.callSync(req)
    }

    // generateWithImageFiles
    public func generateWithImageFiles(model: String, prompt: String, imageFiles: ArrayList<File>, options!: Options = Options()): OllamaResult {
        let images = ArrayList<String>()
        for (f in imageFiles) {
            images.add(Utils.encodeFileToBase64(f))
        }
        let req = OllamaGenerateRequest(model, prompt, images)
        req.options = options.optionsMap
        let caller = OllamaGenerateEndpointCaller(host, basicAuth, requestTimeoutSeconds)
        return caller.callSync(req)
    }

    // generateWithImageURLs
    public func generateWithImageURLs(model: String, prompt: String, imageUrls: ArrayList<String>, options!: Options = Options()): OllamaResult {
        let images = ArrayList<String>()
        for (url in imageUrls) {
            images.add(Utils.loadImageBase64FromUrl(url))
        }
        let req = OllamaGenerateRequest(model, prompt, images)
        req.options = options.optionsMap
        let caller = OllamaGenerateEndpointCaller(host, basicAuth, requestTimeoutSeconds)
        return caller.callSync(req)
    }
    
    public func chat(model: String, messages: ArrayList<OllamaChatMessage>): OllamaChatResult {
        let builder = OllamaChatRequestBuilder.getInstance(model)
        return chat(builder.withMessages(messages).build())
    }

    public func chat(request: OllamaChatRequest): OllamaChatResult {
        let caller = OllamaChatEndpointCaller(host, basicAuth, requestTimeoutSeconds)
        return caller.callSync(request)
    }


    private func getRequestBuilderDefault(url: String): HttpRequestBuilder {
        
        let hb = HttpRequestBuilder().url(url).header("Content-Type", "application/json")
            .readTimeout(requestTimeoutSeconds * Duration.second).writeTimeout(requestTimeoutSeconds * Duration.second)
        if (isBasicAuthCredentialsSet()) {
            hb.header("Authorization", getBasicAuthHeaderValue())
        }
        return hb
    }

    private func isBasicAuthCredentialsSet(): Bool {
        return !basicAuth.isNone()
    }

    private func getBasicAuthHeaderValue(): String {
        let credentialsToEncode = (basicAuth?.username ?? "") + ":" + (basicAuth?.password ?? "")
        return "Basic " + toBase64String(credentialsToEncode.toArray())
    }
}

main() {

    let api = OllamaAPI(host: "http://127.0.0.1:11434")

    let md = api.getModelDetails("qwen2.5")
    println(md)

    let mds = api.listModels()
    println(mds)

    /*
    let result = api.generate("qwen2.5", "Why is the sky blue?")
    println(result)

    let msgSystem = OllamaChatMessage(role: OllamaChatMessageRole.SYSTEM, content: "你是一个精干的秘书，能够把一切都安排得井井有条。")
    let msg = OllamaChatMessage(role: OllamaChatMessageRole.USER, content: "hello")
 
    let result2 = api.chat("qwen2.5", ArrayList<OllamaChatMessage>([msgSystem, msg]))
    println(result2.toString())
    */


    // let e = OllamaErrorResponse()
    // e.error = "666666"
    // let jstr = e.toJson()
    // println(jstr)

    // let e2 = OllamaErrorResponse.fromJson(jstr)
    // println(e2.error)
}