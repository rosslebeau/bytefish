import Vapor
import Foundation

class LinkController: Controller {
    typealias Item = Link

    var database: Database

    required init(application: Application) {
        Log.info("Link controller created")
        database = Database.database
    }

    func index(_ request: Request) throws -> ResponseRepresentable {
        return Json([
            "controller": "LinkController.index"
        ])
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

            return link.makeJson()
        }
        catch {
            return "Failed to add link to database"
        }
    }

    func show(_ request: Request, item link: Link) throws -> ResponseRepresentable {
        return Json([
            "controller": "LinkController.show",
            "link": link
        ])
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
