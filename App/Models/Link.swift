import Vapor
import Foundation

enum LinkError: ErrorProtocol {
    case InvalidURL
}

final class Link {
    var id: String
    var seq: Int64
    var originalUrl: NSURL
    var shortUrl: NSURL

    init(id: String, seq: Int64, originalUrl: NSURL, shortUrl: NSURL) {
        self.id = id
        self.seq = seq
        self.originalUrl = originalUrl
        self.shortUrl = shortUrl
    }
}

extension Link: JsonRepresentable {
    func makeJson() -> Json {
        return Json([
            "id": "\(id)",
            "originalUrl": "\(originalUrl)",
            "shortUrl:": "\(shortUrl)"
        ])
    }
}

extension Link: StringInitializable {
    convenience init?(from string: String) throws {
        return nil
        // guard let url = NSURL(string: string) else {
        //     throw LinkError.InvalidURL
        // }
        // self.init(originalUrl: url)
    }
}
