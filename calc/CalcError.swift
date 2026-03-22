import Foundation

/// Errors reported by the calculator during parsing or evaluation.
enum CalcError: Error, CustomStringConvertible {
    case missingExpression
    case expectedNumber(String)
    case unexpectedToken(String)
    case divisionByZero
    case integerOverflow

    var description: String {
        switch self {
        case .missingExpression:
            return "Missing expression"
        case .expectedNumber(let token):
            return "Expected number but found '\(token)'"
        case .unexpectedToken(let token):
            return "Unexpected token '\(token)'"
        case .divisionByZero:
            return "Division by zero"
        case .integerOverflow:
            return "Integer overflow"
        }
    }
}
