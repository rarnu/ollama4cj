package ollama4cj.models

import std.collection.ArrayList
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonToken
import encoding.json.stream.JsonDeserializable
import ollama4cj.utils.FromJSON
import std.io.ByteBuffer


public class ListModelsResponse <: JsonDeserializable<ListModelsResponse> & FromJSON<ListModelsResponse> {

    public ListModelsResponse(
        public var models!: ArrayList<Model> = ArrayList<Model>()
    ) {

    }

    public static func fromJson(jsonStr: String): ListModelsResponse {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public static func fromJson(reader: JsonReader): ListModelsResponse {
        let result = ListModelsResponse()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "models" => result.models = reader.readValue<ArrayList<Model>>()
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