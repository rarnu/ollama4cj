package ollama4cj.models

import std.collection.ArrayList
import encoding.json.JsonObject
import encoding.json.JsonArray
import encoding.json.JsonString
import encoding.base64.toBase64String
import encoding.base64.fromBase64String
import encoding.json.stream.JsonReader
import encoding.json.stream.JsonDeserializable
import ollama4cj.utils.FromJSON
import ollama4cj.utils.ToJSONObject
import std.io.ByteBuffer

public class OllamaChatMessage <: ToString & JsonDeserializable<OllamaChatMessage> & FromJSON<OllamaChatMessage> & ToJSONObject {

    public OllamaChatMessage(
        public var role!: OllamaChatMessageRole = OllamaChatMessageRole.USER,
        public var content!: String = "",
        public var images!: ArrayList<Array<Byte>> = ArrayList<Array<Byte>>()) {

    }

    public func toString(): String {
        return "{role: ${role}, content: ${content}}"
    }

    public func toJsonObject(): JsonObject {
        let jo = JsonObject()
        jo.put("role", JsonString(role.roleName))
        jo.put("content", JsonString(content))
        let jarr = JsonArray()
        for (img in images) {
            jarr.add(JsonString(toBase64String(img)))
        }
        jo.put("images", jarr)
        return jo
    }

    public static func fromJson(jsonStr: String): OllamaChatMessage {
        let bas = ByteBuffer()
        unsafe { bas.write(jsonStr.rawData()) }
        let reader = JsonReader(bas)
        return fromJson(reader)
    }

    public static func fromJson(r: JsonReader): OllamaChatMessage {
        let res = OllamaChatMessage()
        while(let Some(v) <- r.peek()) {
            match (v) {
                case BeginObject =>
                    r.startObject()
                    while(r.peek() != EndObject) {
                        let n = r.readName()
                        match (n) {
                            case "role" => res.role = OllamaChatMessageRole.getRole(r.readValue<String>())
                            case "content" => res.content = r.readValue<String>()
                            case "images" => res.images = ArrayList(r.readValue<Array<String>>().map { it => 
                                fromBase64String(it) ?? Array<Byte>()
                            })
                            case _ => ()
                        }
                    }
                    r.endObject()
                    break
                case _ => ()
            }
        }
        return res
    }
}
