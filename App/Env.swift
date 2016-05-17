import Foundation

struct Env {
    static let MongoUsername = NSProcessInfo.processInfo().environment["BYTEFISH_MONGO_USERNAME"]!
    static let MongoPassword = NSProcessInfo.processInfo().environment["BYTEFISH_MONGO_PASSWORD"]!
    static let MongoHost = NSProcessInfo.processInfo().environment["BYTEFISH_MONGO_HOST"]!
    static let MongoPort = NSProcessInfo.processInfo().environment["BYTEFISH_MONGO_PORT"]!
    static let MongoDbName = NSProcessInfo.processInfo().environment["BYTEFISH_MONGO_DB_NAME"]!

    static let ShortenerHost = NSProcessInfo.processInfo().environment["BYTEFISH_SHORTENER_HOST"]!
}
