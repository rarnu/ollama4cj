package ollama4cj.utils

public interface Consumer<T> {
    func accept(var1: T): Unit
}