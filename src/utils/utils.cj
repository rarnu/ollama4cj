package ollama4cj.utils

import net.http.ClientBuilder
import std.fs.File
import std.fs.OpenMode
import encoding.base64.toBase64String
import std.io.ByteBuffer

public class Utils {


    public static func loadImageBytesFromUrl(imageUrl: String): Array<Byte> {
        if (imageUrl.startsWith("http")) {
            // 从网络获取
            let cli = ClientBuilder().build()
            let resp = cli.get(imageUrl)
            let bytes = Array<Byte>(resp.bodySize.getOrDefault { 0 }) { _ => 0 }
            _ = resp.body.read(bytes)
            cli.close()
            return bytes
        } else {
            // 本地文件
            let f = File(imageUrl, OpenMode.Read)
            let bytes = Array<Byte>(f.length) { _ => 0 }
            _ = f.read(bytes)
            f.close()
            return bytes
        }
    }

    public static func encodeFileToBase64(f: File): String {
        let bytes = Array<Byte>(f.length) { _ => 0 }
        _ = f.read(bytes)
        f.close()
        return toBase64String(bytes)
    }

    public static func loadImageBase64FromUrl(url: String): String {
        let cli = ClientBuilder().build()
        let resp = cli.get(url)
        let bytes = Array<Byte>(resp.bodySize.getOrDefault { 0 }) { _ => 0 }
        _ = resp.body.read(bytes)
        cli.close()
        return toBase64String(bytes)
    }
}