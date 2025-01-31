package ollama4cj.models

import ollama4cj.utils.FromJSON
import encoding.json.stream.JsonDeserializable
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonToken
import ollama4cj.utils.ToJSON
import ollama4cj.utils.ToJSONObject
import encoding.json.JsonObject
import encoding.json.JsonString
import encoding.json.JsonInt
import std.io.ByteBuffer


public class Model <: JsonDeserializable<Model> & FromJSON<Model> & ToJSON & ToString {

    public Model(
        public var name!: String = "",
        public var model!: String = "",
        public var modifiedAt!: String = "",
        public var expiresAt!: String = "",
        public var digest!: String = "",
        public var size!: Int64 = 0,
        public var details!: ModelMeta = ModelMeta()
    ) {

    }

    public func getModelName(): String {
        return name.split(":")[0]
    }

    public func getModelVersion(): String {
        return name.split(":")[1]
    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("name", JsonString(name))
        jo.put("model", JsonString(model))
        jo.put("modified_at", JsonString(modifiedAt))
        jo.put("expires_at", JsonString(expiresAt))
        jo.put("digest", JsonString(digest))
        jo.put("size", JsonInt(size))
        jo.put("details", details.toJsonObject())
        return jo.toJsonString()
    }

    public static func fromJson(jsonStr: String): Model {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData())}
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public static func fromJson(reader: JsonReader): Model {
        let result = Model()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "name" => result.name = reader.readValue<String>()
                            case "model" => result.model = reader.readValue<String>()
                            case "modified_at" => result.modifiedAt = reader.readValue<String>()
                            case "expires_at" => result.expiresAt = reader.readValue<String>()
                            case "digest" => result.digest = reader.readValue<String>()
                            case "size" => result.size = reader.readValue<Int64>()
                            case "details" => result.details = reader.readValue<ModelMeta>()
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

}
