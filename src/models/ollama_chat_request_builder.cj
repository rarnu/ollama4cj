package ollama4cj.models

import std.collection.ArrayList
import ollama4cj.utils.Options
import ollama4cj.utils.Utils
import std.fs.File

public class OllamaChatRequestBuilder {

    private var request: OllamaChatRequest;

    private OllamaChatRequestBuilder(model: String, messages: ArrayList<OllamaChatMessage>) {
        request = OllamaChatRequest(model: model, messages: messages)
    }

    public static func getInstance(model: String): OllamaChatRequestBuilder {
        return OllamaChatRequestBuilder(model, ArrayList<OllamaChatMessage>())
    }

    public func build(): OllamaChatRequest {
        return request;
    }

    public func reset() {
        request = OllamaChatRequest(model: request.model, messages: ArrayList<OllamaChatMessage>())
    }

    public func withMessage(role: OllamaChatMessageRole, content: String): OllamaChatRequestBuilder {
        return withMessage(role, content, Array<String>())
    }

    public func withMessage(role: OllamaChatMessageRole, content: String, images: ArrayList<File>): OllamaChatRequestBuilder {
        let messages = request.messages
        let binaryImages = ArrayList<Array<Byte>>(images.toArray().map { it => 
            try {
                let bytes = Array<Byte>(it.length) { _ => 0 }
                _ = it.read(bytes)
                return bytes
            } catch (e: Exception) {
                return Array<Byte>()
            }
        })
        messages.add(OllamaChatMessage(role:role, content: content, images: binaryImages))
        return this
    }

    public func withMessage(role: OllamaChatMessageRole, content: String, imageUrls: Array<String>): OllamaChatRequestBuilder {
        let messages = request.messages
        let binaryImages = ArrayList<Array<Byte>>()
        if (!imageUrls.isEmpty()) {
            for (imageUrl in imageUrls) {
                try {
                    binaryImages.add(Utils.loadImageBytesFromUrl(imageUrl))
                } catch (e: Exception) {
                    
                }
            }
        }
        messages.add(OllamaChatMessage(role: role, content:content, images:binaryImages))
        return this
    }

    public func withMessages(messages: ArrayList<OllamaChatMessage>): OllamaChatRequestBuilder {
        return OllamaChatRequestBuilder(request.model, messages)
    }

    public func withOptions(options: Options): OllamaChatRequestBuilder {
        request.options = options.optionsMap
        return this
    }

    public func withJsonResponse(): OllamaChatRequestBuilder {
        request.format = "json"
        return this
    }

    public func withTemplate(template: String): OllamaChatRequestBuilder {
        request.template = template
        return this
    }

    public func withKeepAlive(keepAlive: Int64): OllamaChatRequestBuilder {
        request.keepAlive = keepAlive
        return this
    }
}