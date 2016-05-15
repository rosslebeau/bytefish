import Vapor
import MongoKitten
import Foundation

enum DatabaseLinkError: ErrorProtocol {
    case SequencerFailed
    case SequencerLockTimeout
}

extension Database {
    static let SequencerId = "linkSequence"
    static let SequenceKey = "seq"

    static let sequencerQueue = dispatch_queue_create("com.bytefish.linkSequenceQueue", nil)
    static let sequencerLock = Lock()
    static let sequencerQuery: Query = Database.IdKey == SequencerId

    func createLink(originalUrl: NSURL) throws -> Link? {
        do {
            let linkId = BSON.ObjectId()

            let seq = try nextSequence()

            let shortUrl = try Shortener.generateShortenedUrl(fromSeq: seq)

            let link = Link(id: linkId.hexString, seq: seq, originalUrl: originalUrl, shortUrl: shortUrl)

            let linkDocument: Document = try link.toDocument()
            let createdLinkDocument = try links.insert(linkDocument)

            return Link(document: createdLinkDocument)
        }
        catch {
            Log.error("Failed to insert link")
            return nil
        }
    }

    func nextSequence() throws -> Int64 {
        Database.sequencerLock.lock()

        guard let seqDoc = try linkSequencer.findOne(matching: Database.sequencerQuery) else {
            throw DatabaseLinkError.SequencerFailed
        }

        guard let seq = seqDoc[Database.SequenceKey].int64Value else {
            throw DatabaseLinkError.SequencerFailed
        }

        let nextSeq = seq + 1

        try linkSequencer.update(matching: [Database.IdKey: ~Database.SequencerId], to: [Database.SequenceKey: ~nextSeq])

        Database.sequencerLock.unlock()

        return nextSeq
    }
}

extension Link {
    static let SeqKey = "seq"
    static let OriginalUrlKey = "originalUrl"
    static let ShortUrlKey = "shortUrl"

    convenience init?(document: Document) {
        guard let objId = document[Database.IdKey].objectIdValue else {
            return nil
        }

        guard let oUrl = NSURL(string: document[Link.OriginalUrlKey].string) else {
            return nil
        }

        guard let sUrl = NSURL(string: document[Link.ShortUrlKey].string) else {
            return nil
        }

        guard let s = document[Link.SeqKey].int64Value else {
            return nil
        }

        self.init(id: objId.hexString, seq: s, originalUrl: oUrl, shortUrl: sUrl)
    }

    func toDocument() throws -> Document {
        return try [
            Database.IdKey: ~BSON.ObjectId(id),
            Link.SeqKey: ~seq,
            Link.OriginalUrlKey: ~originalUrl.absoluteString,
            Link.ShortUrlKey: ~shortUrl.absoluteString
        ]
    }
}
