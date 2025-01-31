package ollama4cj.models

import std.collection.ArrayList
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonDeserializable
import encoding.json.stream.JsonToken
import std.io.ByteBuffer
import encoding.json.JsonObject
import encoding.json.JsonString
import encoding.json.JsonArray
import encoding.json.JsonBool
import encoding.json.JsonNull
import encoding.json.JsonInt
import ollama4cj.utils.FromJSON
import ollama4cj.utils.ToJSONObject

public class OllamaGenerateResponseModel <: JsonDeserializable<OllamaGenerateResponseModel> & FromJSON<OllamaGenerateResponseModel> & ToJSONObject {

    public OllamaGenerateResponseModel(
        public var model!: String = "",
        public var createdAt!: String = "",
        public var response!: String = "",
        public var done!: Bool = false,
        public var doneReason!: String = "",
        public var totalDuration!: Int64 = 0,
        public var loadDuration!: Int64 = 0,
        public var promptEvalDuration!: Int64 = 0,
        public var evalDuration!: Int64 = 0,
        public var promptEvalCount!: Int64 = 0,
        public var evalCount!: Int64 = 0,
        public var context!: Array<Int64> = Array<Int64>()
    ) {

    }

    public static func fromJson(reader: JsonReader): OllamaGenerateResponseModel {
        let result = OllamaGenerateResponseModel()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "model" => result.model = reader.readValue<String>()
                            case "created_at" => result.createdAt = reader.readValue<String>()
                            case "response" => result.response = reader.readValue<String>()
                            case "done" => result.done = reader.readValue<Bool>()
                            case "done_reason" => result.doneReason = reader.readValue<String>()
                            case "total_duration" => result.totalDuration = reader.readValue<Int64>()
                            case "load_duration" => result.loadDuration = reader.readValue<Int64>()
                            case "prompt_eval_duration" => result.promptEvalDuration = reader.readValue<Int64>()
                            case "eval_duration" => result.evalDuration = reader.readValue<Int64>()
                            case "prompt_eval_count" => result.promptEvalCount = reader.readValue<Int64>()
                            case "eval_count" => result.evalCount = reader.readValue<Int64>()
                            case "context" => result.context = reader.readValue<Array<Int64>>()
                            case _ => ()
                        }
                    }
                    reader.endObject()
                    break
                case _ => ()
            }
        }
        return result
    }

    public static func fromJson(jsonString: String): OllamaGenerateResponseModel {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonString.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public func toJsonObject(): JsonObject {
        let jo = JsonObject()
        jo.put("model", JsonString(model))
        jo.put("created_at", JsonString(createdAt))
        jo.put("response", JsonString(response))
        jo.put("done", JsonBool(done))
        jo.put("done_reason", JsonString(doneReason))
        jo.put("total_duration", JsonInt(totalDuration))
        jo.put("load_duration", JsonInt(loadDuration))
        jo.put("prompt_eval_duration", JsonInt(promptEvalDuration))
        jo.put("eval_duration", JsonInt(evalDuration))
        jo.put("prompt_eval_count", JsonInt(promptEvalCount))
        jo.put("eval_count", JsonInt(evalCount))
        let jarr = JsonArray()
        for (i in context) {
            jarr.add(JsonInt(i))
        }
        jo.put("context", jarr)
        return jo
    }
}
