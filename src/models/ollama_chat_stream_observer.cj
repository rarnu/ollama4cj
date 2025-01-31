package ollama4cj.models

public class OllamaChatStreamObserver <: OllamaTokenHandler {

    private var message = ""

    public OllamaChatStreamObserver(public let streamHandler: ?OllamaStreamHandler) {

    }

    public override func accept(token: OllamaChatResponseModel): Unit {
        if (!streamHandler.isNone()) {
            message += token.message?.content ?? ""
            streamHandler?.accept(message)
        }
    }
    
}