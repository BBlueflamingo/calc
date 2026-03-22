import Foundation

/// Provides sequential access to command-line tokens.
final class TokenStream {
    private let tokens: [String]
    private var index: Int = 0

    init(tokens: [String]) {
        self.tokens = tokens
    }

    var isAtEnd: Bool {
        return index >= tokens.count
    }

    func peek() -> String? {
        guard !isAtEnd else {
            return nil
        }
        return tokens[index]
    }

    @discardableResult
    func consume() -> String? {
        guard !isAtEnd else {
            return nil
        }

        let token = tokens[index]
        index += 1
        return token
    }
}
