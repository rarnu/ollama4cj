package ollama4cj.models

import std.collection.List;
import std.collection.ArrayList;
import ollama4cj.exceptions.RoleNotFoundException

public class OllamaChatMessageRole <: ToString {
    
    private static let ROLES = ArrayList<OllamaChatMessageRole>();

    public static let SYSTEM = OllamaChatMessageRole("system")

    public static let USER = OllamaChatMessageRole("user")

    public static let ASSISTANT = OllamaChatMessageRole("assistant")

    public static let TOOL = OllamaChatMessageRole("tool")

    private OllamaChatMessageRole(public let roleName: String) {
        ROLES.add(this)
    }

    public static func newCustomRole(roleName: String): OllamaChatMessageRole {
        let customRole = OllamaChatMessageRole(roleName)
        ROLES.add(customRole)
        return customRole
    }

    public static func getRoles(): ArrayList<OllamaChatMessageRole> {
        return ArrayList(ROLES)
    }

    public static func getRole(roleName: String): OllamaChatMessageRole {
        for (role in ROLES) {
            if (role.roleName == roleName) {
                return role
            }
        }
        throw RoleNotFoundException("Invalid role name: ${roleName}")
    }

    override public func toString(): String {
        return roleName;
    }

}