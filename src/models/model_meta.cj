package ollama4cj.models

import ollama4cj.utils.ToJSONObject
import encoding.json.JsonObject
import encoding.json.JsonString
import encoding.json.JsonArray
import encoding.json.stream.JsonDeserializable
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonToken


public class ModelMeta <: ToJSONObject & JsonDeserializable<ModelMeta> {

    public ModelMeta(
        public var format!: String = "",
        public var family!: String = "",
        public var families!: Array<String> = Array<String>(),
        public var parameterSize!: String = "",
        public var quantizationLevel!: String = "",
        public var parentModel!: String = ""
    ) {

    }

    public func toJsonObject(): JsonObject {
        let jo = JsonObject()
        jo.put("format", JsonString(format))
        jo.put("family", JsonString(family))
        let jarr = JsonArray()
        for (f in families) {
            jarr.add(JsonString(f))
        }
        jo.put("families", jarr)
        jo.put("parameter_size", JsonString(parameterSize))
        jo.put("quantization_level", JsonString(quantizationLevel))
        return jo
    }

    public static func fromJson(reader: JsonReader): ModelMeta {
        let result = ModelMeta()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "format" => result.format = reader.readValue<String>()
                            case "family" => result.family = reader.readValue<String>()
                            case "parameter_size" => result.parameterSize = reader.readValue<String>()
                            case "quantization_level" => result.quantizationLevel = reader.readValue<String>()
                            case "families" => result.families = reader.readValue<Array<String>>()
                            case "parent_model" => result.parentModel = reader.readValue<String>()
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
}
