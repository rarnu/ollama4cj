package ollama4cj.utils

public class PromptBuilder {

    private let prompt = StringBuilder()

    public PromptBuilder() {

    }

    public func add(text: String): PromptBuilder {
        prompt.append(text)
        return this
    }

    public func addLine(text: String): PromptBuilder {
        prompt.append(text)
        prompt.append("\n")
        return this
    }

    public func addSeparator(): PromptBuilder {
        prompt.append("\n--------------------------------------------------\n")
        return this
    }

    public func build(): String {
        return prompt.toString()
    }
}