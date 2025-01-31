package ollama4cj.utils

import encoding.json.JsonObject

public interface ToJSON {
    func toJson(): String
}

public interface ToJSONObject {
    func toJsonObject(): JsonObject
}

public interface FromJSON<T> {
    static func fromJson(jsonSt: String): T
}