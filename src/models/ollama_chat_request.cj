package ollama4cj.models

import std.collection.ArrayList
import std.collection.HashMap

import encoding.json.stream.JsonWriter
import std.io.ByteBuffer
import ollama4cj.utils.ToJSON
import encoding.json.JsonObject
import encoding.json.JsonString
import encoding.json.JsonBool
import encoding.json.JsonInt
import encoding.json.JsonArray

public class OllamaChatRequest <: OllamaCommonRequest & ToJSON {

    public OllamaChatRequest(
        model!: String = "",
        public var messages!: ArrayList<OllamaChatMessage> = ArrayList<OllamaChatMessage>()
    ) {
        super(model: model, format: "json", options: HashMap<String, ToString>(), template:"", stream:false, keepAlive:0)
    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("model", JsonString(model))
        jo.put("format", JsonString(format))
        jo.put("template", JsonString(template))
        jo.put("stream", JsonBool(stream))
        jo.put("keep_alive", JsonInt(keepAlive))

        let jopt = JsonObject()
        for ((k, v) in options) {
            jopt.put(k, JsonString("${v}"))
        }
        jo.put("options", jopt)

        let jarr = JsonArray()
        for (m in messages) {
            jarr.add(m.toJsonObject())
        }

        jo.put("messages", jarr)
        
        return jo.toJsonString()
        
    }

}