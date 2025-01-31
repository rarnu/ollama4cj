package ollama4cj.utils

import net.http.ClientBuilder
import net.http.HttpRequest
import std.io.StringReader

public class HttpUtils {

    public static func call(req: HttpRequest): (Int64, String) {
        let cli = ClientBuilder().build()
        let resp = cli.send(req)
        let statusCode = Int64(resp.status)
        let body = StringReader(resp.body).readToEnd()
        cli.close()
        return (statusCode, body)
    }

}