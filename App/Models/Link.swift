import Vapor
import Foundation

enum LinkError: ErrorProtocol {
    case InvalidURL
}

final class Link {
    var id: String
    var seq: Int64
    var slug: String
    var originalUrl: NSURL
    var shortUrl: NSURL

    init(id: String, seq: Int64, slug: String, originalUrl: NSURL, shortUrl: NSURL) {
        self.id = id
        self.seq = seq
        self.slug = slug
        self.originalUrl = originalUrl
        self.shortUrl = shortUrl
    }
}

extension Link: JsonRepresentable {
    func makeJson() -> Json {
        return Json([
            "id": "\(id)",
            "slug": "\(slug)",
            "originalUrl": "\(originalUrl)",
            "shortUrl:": "\(shortUrl)"
        ])
    }
}

extension Link: StringInitializable {
    convenience init?(from slug: String) throws {
        self.init(fromSlug: slug)
    }
}

extension String {
    func hasHttpPrefix() -> Bool {
        return self.hasPrefix("http://") || self.hasPrefix("https://")
    }

    func hasScheme() -> Bool {
        return range(of: "://") != nil
    }
}
