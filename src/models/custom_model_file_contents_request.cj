package ollama4cj.models

import encoding.json.JsonObject
import encoding.json.JsonString
import ollama4cj.utils.ToJSON

public class CustomModelFileContentsRequest <: ToJSON {

    public CustomModelFileContentsRequest(
        public var name: String,
        public var modelfile: String
    ) {

    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("name", JsonString(name))
        jo.put("modelfile", JsonString(modelfile))
        return jo.toJsonString()
    }
}