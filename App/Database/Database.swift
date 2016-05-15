import Vapor
import MongoKitten

class Database {
    static let IdKey = "_id"

    static let database = Database(name: "bytefish", port: "27017")!

    var server: MongoKitten.Server
    var mongo: MongoKitten.Database
    var links: MongoKitten.Collection
    var linkSequencer: MongoKitten.Collection

    init?(name: String, port: String) {
        do {
            server = try Server("mongodb://\(Secrets.MongoUsername):\(Secrets.MongoPassword)@localhost:\(port)", automatically: true)
            mongo = server[name]
            links = mongo["links"]

            linkSequencer = mongo["linkSequencer"]
            // We want to keep only one document in the linkSequencer.
            // Create it if it doesn't exist.
            do {
                if try linkSequencer.count() == 0 {
                    try linkSequencer.insert([Database.IdKey: ~Database.SequencerId, Database.SequenceKey: ~Int64(0)])
                }
            }
            catch {
                return nil
            }
        } catch {
            print("MongoDB is not available on the given host and port")
            return nil
        }
    }
}
