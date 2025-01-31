package ollama4cj.models

import encoding.json.stream.JsonDeserializable
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonToken
import ollama4cj.utils.FromJSON
import std.io.ByteBuffer


public class ModelPullResponse <: JsonDeserializable<ModelPullResponse> & FromJSON<ModelPullResponse> {

    public ModelPullResponse(
        public var status!: String = "",
        public var digest!: String = "",
        public var total!: Int64 = 0,
        public var completed!: Int64 = 0
    ) {

    }

    public static func fromJson(jsonStr: String): ModelPullResponse {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public static func fromJson(reader: JsonReader): ModelPullResponse {
        let result = ModelPullResponse()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "status" => result.status = reader.readValue<String>()
                            case "digest" => result.digest = reader.readValue<String>()
                            case "total" => result.total = reader.readValue<Int64>()
                            case "completed" => result.completed = reader.readValue<Int64>()
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