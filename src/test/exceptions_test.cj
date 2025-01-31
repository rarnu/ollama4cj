package ollama4cj.test

import std.unittest.testmacro.Test
import std.unittest.testmacro.TestCase
import std.unittest.testmacro.Assert
import ollama4cj.exceptions.OllamaBaseException


@Test
public class ExceptionsTest {

    @TestCase
    public func ollamaException() {
        let ex = OllamaBaseException("message")
        @Assert(ex.message, "message")
    }
}