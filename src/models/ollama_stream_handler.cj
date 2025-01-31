package ollama4cj.models

public interface OllamaStreamHandler {
    func accept(message: String): Unit
}