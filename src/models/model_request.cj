package ollama4cj.models

import ollama4cj.utils.ToJSON
import encoding.json.JsonObject
import encoding.json.JsonString

public class ModelRequest <: ToJSON {

    public ModelRequest(public var name: String) {

    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("name", JsonString(name))
        return jo.toJsonString()
    }
}