package ollama4cj.test

import std.unittest.testmacro.Test
import std.unittest.testmacro.TestCase
import ollama4cj.models.OllamaErrorResponse

@Test
public class JsonTest {

    @TestCase
    public func test1() {
        let e = OllamaErrorResponse()
        e.error = "666666"
        let jstr = e.toJson()
        println(jstr)
    }
} 