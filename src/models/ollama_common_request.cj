package ollama4cj.models

import std.collection.HashMap

public open class OllamaCommonRequest {

    public OllamaCommonRequest(
        protected var model!: String = "",
        protected var format!: String = "json",
        protected var options!: HashMap<String, ToString> = HashMap<String, ToString>(),
        protected var template!: String = "",
        protected var stream!: Bool = false,
        protected var keepAlive!: Int64 = 0 // keep_alive
    ) {
        
    }
}