package ollama4cj.models

import ollama4cj.utils.ToJSON
import std.collection.ArrayList
import encoding.json.JsonObject
import encoding.json.JsonArray
import encoding.json.JsonString
import encoding.json.JsonBool
import encoding.json.JsonInt
import std.collection.HashMap

public class OllamaGenerateRequest <: OllamaCommonRequest & ToJSON  {

    public var images = ArrayList<String>()
    public var system = ""
    public var raw = false

    public OllamaGenerateRequest(model!: String = "", public var prompt!: String = "") {
        super(model: model, format: "json", options: HashMap<String, ToString>(), template:"", stream:false, keepAlive:0)
    }

    public init(model: String, prompt: String, images: ArrayList<String>) {
        super(model: model)
        this.prompt = prompt
        this.images = images
    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("model", JsonString(model))
        jo.put("prompt", JsonString(prompt))
        jo.put("format", JsonString(format))
        jo.put("stream", JsonBool(stream))

        if (!template.isEmpty()) {
            jo.put("template", JsonString(template))
        }
        if (keepAlive != 0) {
            jo.put("keep_alive", JsonInt(keepAlive))
        }
        if (!options.isEmpty()) {
            let jopt = JsonObject()
            for ((k, v) in options) {
                jopt.put(k, JsonString("${v}"))
            }
            jo.put("options", jopt)
        }
        if (!system.isEmpty()) {
            jo.put("system", JsonString(system))
        }
        if (raw) {
            jo.put("raw", JsonBool(raw))
        }
        if (!images.isEmpty()) {
            let jarr = JsonArray()
            for (m in images) {
                jarr.add(JsonString(m))
            }
            jo.put("images", jarr)
        }
        
        return jo.toJsonString()
    }

}
