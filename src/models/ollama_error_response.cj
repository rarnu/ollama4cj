package ollama4cj.models

import encoding.json.stream.JsonReader
import encoding.json.stream.JsonToken
import encoding.json.stream.JsonWriter
import std.io.ByteBuffer
import std.io.StringReader
import ollama4cj.utils.FromJSON

public class OllamaErrorResponse <: FromJSON<OllamaErrorResponse> {
    
    public var error: String = ""

    public func toJson(): String {
        var bas = ByteBuffer()
        let writer = JsonWriter(bas)
        writer.startObject()
        writer.writeName("error").writeValue(error)
        writer.endObject()
        writer.flush()
        return StringReader(bas).readToEnd()
    }

    public static func fromJson(jsonStr: String): OllamaErrorResponse {

        var bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData()) }
        let reader = JsonReader(bas)
        
        let result = OllamaErrorResponse()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "error" => result.error = reader.readValue<String>()
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