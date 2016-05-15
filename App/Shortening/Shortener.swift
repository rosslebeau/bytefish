import Vapor
import Foundation

enum ShortenerError: ErrorProtocol {
    case FailedURL
    case InvalidId
}

class Shortener {
    static let alphabet: [Character] = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters)

    static func generateShortenedUrl(fromSeq seq: Int64) throws -> NSURL {
        return try urlForShortenedValue(generateShortenedValue(fromSeq: seq))
    }

    static func generateShortenedValue(fromSeq seq: Int64) throws -> String {
        let short = intToAlphabet(int: seq, alphabet: alphabet)
        print("alphabet: \(short)")
        return short
    }

    static func urlForShortenedValue(_ shortenedValue: String) throws -> NSURL {
        guard let url = NSURL(string: "byte.fish/\(shortenedValue)") else {
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
}
