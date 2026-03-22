import Foundation

/// Coordinates command-line calculation by delegating to the parser.
final class Calculator {
    func calculate(args: [String]) throws -> Int {
        let parser = Parser(tokens: args)
        return try parser.parse()
    }
}
