package  ollama4cj.exceptions

public class OllamaBaseException <: Exception {
    public OllamaBaseException(message: String) {
        super(message)
    }
}


public class RoleNotFoundException <: Exception {
    public RoleNotFoundException(message: String) {
        super(message);
    }
}

public class ToolInvocationException <: Exception {
    public ToolInvocationException(message: String, var e: Exception) {
        super(message);
    }
}

public class ToolNotFoundException <: Exception {
    public ToolNotFoundException(message: String) {
        super(message);
    }
}
