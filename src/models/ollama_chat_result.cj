package ollama4cj.models

import std.collection.ArrayList
import encoding.json.JsonObject
import encoding.json.JsonArray
import std.io.ByteBuffer
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonDeserializable
import ollama4cj.utils.ToJSON
import ollama4cj.utils.FromJSON

public class OllamaChatResult <: ToString & JsonDeserializable<OllamaChatResult> & ToJSON & FromJSON<OllamaChatResult> {

    public OllamaChatResult(
        public var responseModel!: OllamaChatResponseModel = OllamaChatResponseModel(),
        public var chatHistory!: ArrayList<OllamaChatMessage> = ArrayList<OllamaChatMessage>()
    ) {
        appendAnswerToChatHistory(responseModel)
    }

    private func appendAnswerToChatHistory(response: OllamaChatResponseModel) {
        if (!response.message.isNone()) {
            chatHistory.add(response.message.getOrThrow())
        }
    }

    public func getResponse(): String {
        return responseModel.message?.content ?? ""
    }

    public func getResponseTime(): Int64 {
        return responseModel.totalDuration
    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("responseModel", responseModel.toJsonObject())
        let jarr = JsonArray()
        for (m in chatHistory) {
            jarr.add(m.toJsonObject())
        }
        jo.put("chat_history", jarr)
        return jo.toJsonString()
    }

    public func toString(): String {
        return toJson()
    }

    public static func fromJson(jsonStr: String): OllamaChatResult {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public static func fromJson(r: JsonReader): OllamaChatResult {
        let res = OllamaChatResult()
        while(let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    r.startObject()
                    while(r.peek() != EndObject) {
                        let n = r.readName()
                        match (n) {
                            case "responseModel" => res.responseModel = r.readValue<OllamaChatResponseModel>()
                            case "chat_history" => res.chatHistory = ArrayList(r.readValue<Array<OllamaChatMessage>>())
                            case _ => ()
                        }
                    }
                    r.endObject()
                    break
                case _ => ()
            }
        }

        return res
    }
}