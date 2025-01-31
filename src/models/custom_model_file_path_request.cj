package ollama4cj.models

import encoding.json.JsonObject
import encoding.json.JsonString
import ollama4cj.utils.ToJSON

public class CustomModelFilePathRequest <: ToJSON {

    public CustomModelFilePathRequest(
        public var name: String,
        public var path: String
    ) {

    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("name", JsonString(name))
        jo.put("path", JsonString(path))
        return jo.toJsonString()
    }



}