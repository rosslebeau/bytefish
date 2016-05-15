import Vapor
import Foundation

enum ShortenerError: ErrorProtocol {
    case FailedURL
    case InvalidId
    case InvalidAlphabetCharacter
}

class Shortener {
    static let alphabet: [Character] = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)

    static func generateSlug(fromSeq seq: Int64) throws -> String {
        let short = intToAlphabet(int: seq, alphabet: alphabet)
        return short
    }

    static func urlForSlug(_ slug: String) throws -> NSURL {
        guard let url = NSURL(string: "byte.fish/\(slug)") else {
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
        let intValue = try slugChars.map({ letter in
            return try Shortener.intFromAlphabetLetter(letter)
        }).reduce(Int64(0), combine: +)
        print("intv: \(intValue)")

        return intValue
    }

    static func intFromAlphabetLetter(_ letter: Character) throws -> Int {
        if let index = alphabet.index(of: letter) {
            return index
        }
        else {
            throw ShortenerError.InvalidAlphabetCharacter
        }
    }
}
