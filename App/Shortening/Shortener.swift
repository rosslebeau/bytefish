import Vapor
import Foundation

enum ShortenerError: ErrorProtocol {
    case FailedURL
    case InvalidId
    case InvalidAlphabetCharacter
    case InvalidChecksum
}

class Shortener {
    static let alphabet: [Character] = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)

    static func generateSlug(fromSeq seq: Int64) throws -> String {
        let alphabetEncoded = intToAlphabet(int: seq, alphabet: alphabet)
        let checksum = checksumForSeq(seq)
        return checksum + alphabetEncoded
    }

    static func urlForSlug(_ slug: String) throws -> NSURL {
        guard let url = NSURL(string: "https://guarded-shore-71209.herokuapp.com/\(slug)") else {
            throw ShortenerError.FailedURL
        }

        return url
    }

    static func intToAlphabet(int: Int64, alphabet: [Character]) -> String {
        return String(backwardsIntToAlphabet(int: int, alphabet: alphabet, acc: []).reversed())
    }

    static func backwardsIntToAlphabet(int: Int64, alphabet: [Character], acc: [Character]) -> [Character] {
        if int == 0 {
            return [alphabet.first!]
        }

        let base = Int64(alphabet.count)

        let letter = alphabet[Int(int % base)]
        let remainder = int / base

        var newAcc = acc
        newAcc.append(letter)

        if remainder == 0 {
            return newAcc
        }
        else {
            return backwardsIntToAlphabet(int: remainder, alphabet: alphabet, acc: newAcc)
        }
    }

    static func seqForSlug(_ slug: String) throws -> Int64 {
        let slugChars = Array(slug.characters)
        let checksum = String(slugChars.prefix(upTo: 2))
        let encodedSeq = slugChars.suffix(from: 2)

        let intValue = try encodedSeq.map({ letter in
            return try intFromAlphabetLetter(letter)
        }).reduce(Int64(0), combine: +)

        let checksumFromDecoding = checksumForSeq(intValue)
        
        if checksum == checksumFromDecoding {
            return intValue
        } else {
            throw ShortenerError.InvalidChecksum
        }
    }

    static func intFromAlphabetLetter(_ letter: Character) throws -> Int {
        if let index = alphabet.index(of: letter) {
            return index
        }
        else {
            throw ShortenerError.InvalidAlphabetCharacter
        }
    }

    static func checksumForSeq(_ seq: Int64) -> String {
        let checksumGenerator = seq % (Int64(alphabet.count) ^ 2)
        let backwards = backwardsIntToAlphabet(int: checksumGenerator, alphabet: alphabet, acc: [])

        if (backwards.count == 2) {
            return String(backwards.reversed())
        }
        else {
            return String([alphabet[0], backwards[0]])
        }
    }
}
