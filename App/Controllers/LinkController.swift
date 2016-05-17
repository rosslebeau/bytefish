import Vapor
import Foundation
import Mustache

class LinkController: Controller {
    typealias Item = Link

    var app: Application
    var database: Database

    required init(application: Application) {
        app = application
        database = Database.database
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        return Response(redirect: "/")
    }

    func store(_ request: Request) throws -> ResponseRepresentable {
        guard let originalUrlString = request.data["original_url"].string else {
            return "No URL"
        }

        if originalUrlString.isEmpty {
            return "No URL"
        }

        var cleanUrlString = originalUrlString
        if (!originalUrlString.hasScheme()) {
            cleanUrlString = "http://" + cleanUrlString
        }
        else if (!originalUrlString.hasHttpPrefix()) {
            return "Invalid URL scheme"
        }

        guard let originalUrl = NSURL(string: cleanUrlString) else {
            return "Invalid URL"
        }

        do {
            guard let link = try database.createLink(originalUrl: originalUrl) else {
                return "Failed to add link to database"
            }

            return Response(redirect: "/links/\(link.slug)")
        }
        catch {
            return "Failed to add link to database"
        }
    }

    func show(_ request: Request, item link: Link) throws -> ResponseRepresentable {
        do {
            return try app.view("link.mustache", context: [
                "shortUrl": link.shortUrl.absoluteString,
                "originalUrl": link.originalUrl.absoluteString,
                "charactersInUrl": link.shortUrl.absoluteString.characters.count
            ])
        }
        catch {
            return "Error showing link"
        }
    }

    func update(_ request: Request, item link: Link) throws -> ResponseRepresentable {
      return link.makeJson()
    }

    func destroy(_ request: Request, item link: Link) throws -> ResponseRepresentable {
      return link
    }

    func redirect(_ request: Request, item link: Link) throws -> ResponseRepresentable {
        print("\(link.originalUrl.scheme), \(link.originalUrl.host), \(link.originalUrl.relativeString)")
        return Response(redirect: link.originalUrl.absoluteString)
    }
}
