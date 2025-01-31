package ollama4cj.models

import std.collection.ArrayList

public open class OllamaGenerateStreamObserver {

    private var message = ""

    private var responseParts = ArrayList<OllamaGenerateResponseModel>()

    public OllamaGenerateStreamObserver(private let streamHandler: ?OllamaStreamHandler) {

    }

    public func notify(currentResponsePart: OllamaGenerateResponseModel) {
        responseParts.add(currentResponsePart)
        handleCurrentResponsePart(currentResponsePart)
    }

    protected open func handleCurrentResponsePart(currentResponsePart: OllamaGenerateResponseModel) {
        message += currentResponsePart.response
        streamHandler?.accept(message)
    }
}