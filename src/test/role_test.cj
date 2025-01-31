package ollama4cj.test

import std.unittest.testmacro.Test
import std.unittest.testmacro.TestCase
import std.unittest.testmacro.Assert

import ollama4cj.models.OllamaChatMessageRole

@Test
public class RoleTest {

    @TestCase
    public func testRole() {
        @Assert("${OllamaChatMessageRole.SYSTEM}", "system")
    }

}