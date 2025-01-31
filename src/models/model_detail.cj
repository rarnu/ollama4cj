package ollama4cj.models

import ollama4cj.utils.FromJSON
import encoding.json.stream.JsonDeserializable
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonToken
import std.io.ByteBuffer
import ollama4cj.utils.ToJSON
import encoding.json.JsonObject
import encoding.json.JsonString


public class ModelDetail <: JsonDeserializable<ModelDetail> & FromJSON<ModelDetail> & ToString & ToJSON {

    public ModelDetail(
        public var license!: String = "",
        public var modelFile!: String = "",
        public var parameters!: String = "",
        public var template!: String = "",
        public var system!: String = "",
        public var modifiedAt!: String = "",
        public var details!: ModelMeta = ModelMeta()
    ) {

    }

    public static func fromJson(jsonStr: String): ModelDetail {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public static func fromJson(reader: JsonReader): ModelDetail {
        let result = ModelDetail()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "license" => result.license = reader.readValue<String>()
                            case "modelfile" => result.modelFile = reader.readValue<String>()
                            case "parameters" => result.parameters = reader.readValue<String>()
                            case "template" => result.template = reader.readValue<String>()
                            case "system" => result.system = reader.readValue<String>()
                            case "details" => result.details = reader.readValue<ModelMeta>()
                            case "modified_at" => result.modifiedAt = reader.readValue<String>()
                            case "model_info" => _ = reader.readValueBytes()
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

    public func toString(): String {
      return toJson()
    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("license", JsonString(license))
        jo.put("modelfile", JsonString(modelFile))
        jo.put("parameters", JsonString(parameters))
        jo.put("template", JsonString(template))
        jo.put("system", JsonString(system))
        jo.put("details", details.toJsonObject())
        return jo.toJsonString()
    }
}