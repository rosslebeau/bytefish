import Vapor
import MongoKitten

class Database {
    static let IdKey = "_id"
    static let database = Database(username: Env.MongoUsername, password: Env.MongoPassword, host: Env.MongoHost, port: Env.MongoPort)!

    var server: MongoKitten.Server
    var db: MongoKitten.Database
    var links: MongoKitten.Collection
    var linkSequencer: MongoKitten.Collection

    init?(username: String, password: String, host: String, port: String) {
        do {
            server = try Server("mongodb://\(username):\(password)@\(host):\(port)", automatically: true)
            db = server[Env.MongoDbName]
            links = db["links"]

            linkSequencer = db["linkSequencer"]
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
