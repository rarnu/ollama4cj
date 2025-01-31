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

public class OllamaChatResponseModel <: JsonDeserializable<OllamaChatResponseModel> & FromJSON<OllamaChatResponseModel> & ToJSONObject {

    public OllamaChatResponseModel(
        public var model!: String = "",
        public var createdAt!: String = "", // created_at
        public var doneReason!: String = "", // done_reason
        public var message!: ?OllamaChatMessage = None,
        public var done!: Bool = false,
        public var error!: String = "",
        public var context!: ArrayList<Int64> = ArrayList<Int64>(),
        public var totalDuration!: Int64 = 0, // total_duration
        public var loadDuration!: Int64 = 0, // load_duration
        public var promptEvalDuration!: Int64 = 0, // prompt_eval_duration
        public var evalDuration!: Int64 = 0, // eval_duration
        public var promptEvalCount!: Int64 = 0, // prompt_eval_count
        public var evalCount!: Int64 = 0 // eval_count
    ) {

    }

    public static func fromJson(reader: JsonReader): OllamaChatResponseModel {
        let result = OllamaChatResponseModel()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "model" => result.model = reader.readValue<String>()
                            case "created_at" => result.createdAt = reader.readValue<String>()
                            case "done_reason" => result.doneReason = reader.readValue<String>()
                            case "done" => result.done = reader.readValue<Bool>()
                            case "error" => result.error = reader.readValue<String>()
                            case "context" => result.context = reader.readValue<ArrayList<Int64>>()
                            case "total_duration" => result.totalDuration = reader.readValue<Int64>()
                            case "load_duration" => result.loadDuration = reader.readValue<Int64>()
                            case "prompt_eval_duration" => result.promptEvalDuration = reader.readValue<Int64>()
                            case "eval_duration" => result.evalDuration = reader.readValue<Int64>()
                            case "prompt_eval_count" => result.promptEvalCount = reader.readValue<Int64>()
                            case "eval_count" => result.evalCount = reader.readValue<Int64>()
                            case "message" => result.message = reader.readValue<OllamaChatMessage>()
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

    public static func fromJson(jsonString: String): OllamaChatResponseModel {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonString.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public func toJsonObject(): JsonObject {
        let jo = JsonObject()
        jo.put("model", JsonString(model))
        jo.put("created_at", JsonString(createdAt))
        jo.put("done_reason", JsonString(doneReason))
        jo.put("message", message?.toJsonObject() ?? JsonNull())
        jo.put("done", JsonBool(done))
        jo.put("error", JsonString(error))
        jo.put("context", JsonArray(context.toArray().map { it => JsonInt(it) }))
        jo.put("total_duration", JsonInt(totalDuration))
        jo.put("load_duration", JsonInt(loadDuration))
        jo.put("prompt_eval_duration", JsonInt(promptEvalDuration))
        jo.put("eval_duration", JsonInt(evalDuration))
        jo.put("prompt_eval_count", JsonInt(promptEvalCount))
        jo.put("eval_count", JsonInt(evalCount))
        return jo
    }
}