package ollama4cj.models

import ollama4cj.utils.FromJSON
import ollama4cj.utils.ToJSON
import encoding.json.JsonObject
import encoding.json.JsonString
import encoding.json.JsonInt
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonToken
import std.io.ByteBuffer


public class OllamaResult <: FromJSON<OllamaResult> & ToJSON & ToString {

    public OllamaResult(
        public var response!: String = "",
        public var responseTime!: Int64 = 0,
        public var httpStatusCode!: Int64 = 0
    ) {

    }

    public func toString(): String {
        return toJson()
    }

    public func toJson(): String {
        let jo = JsonObject()
        jo.put("response", JsonString(response))
        jo.put("responseTime", JsonInt(responseTime))
        jo.put("httpStatusCode", JsonInt(httpStatusCode))
        return jo.toJsonString()
    }
    
    public static func fromJson(jsonStr: String): OllamaResult {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public static func fromJson(reader: JsonReader): OllamaResult {
        let result = OllamaResult()
        while(let Some(v) <- reader.peek()) {
            match (v) {
                case JsonToken.BeginObject => 
                    reader.startObject()
                    while(reader.peek() != JsonToken.EndObject) {
                        let n = reader.readName()
                        match (n) {
                            case "response" => result.response = reader.readValue<String>()
                            case "responseTime" => result.responseTime = reader.readValue<Int64>()
                            case "httpStatusCode" => result.httpStatusCode = reader.readValue<Int64>()
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