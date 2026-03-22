import Foundation

/// Parses calculator expressions and evaluates them using operator precedence.
final class Parser {
    private let stream: TokenStream

    init(tokens: [String]) {
        self.stream = TokenStream(tokens: tokens)
    }

    func parse() throws -> Int {
        guard !stream.isAtEnd else {
            throw CalcError.missingExpression
        }

        let value = try parseExpression()

        if let extra = stream.peek() {
            throw CalcError.unexpectedToken(extra)
        }

        return value
    }

    private func parseExpression() throws -> Int {
        var value = try parseTerm()

        while let op = nextOperator(), op.isAdditive {
            _ = stream.consume()
            let rhs = try parseTerm()
            value = try apply(op, lhs: value, rhs: rhs)
        }

        return value
    }

    private func parseTerm() throws -> Int {
        var value = try parseFactor()

        while let op = nextOperator(), op.isMultiplicative {
            _ = stream.consume()
            let rhs = try parseFactor()
            value = try apply(op, lhs: value, rhs: rhs)
        }

        return value
    }

    private func parseFactor() throws -> Int {
        guard let token = stream.consume() else {
            throw CalcError.expectedNumber("end of input")
        }

        guard let value = Int(token) else {
            throw CalcError.expectedNumber(token)
        }

        return value
    }

    private func nextOperator() -> OperatorToken? {
        guard let token = stream.peek() else {
            return nil
        }
        return OperatorToken(rawValue: token)
    }

    private func apply(_ op: OperatorToken, lhs: Int, rhs: Int) throws -> Int {
        switch op {
        case .add:
            return try safeAdd(lhs, rhs)
        case .subtract:
            return try safeSubtract(lhs, rhs)
        case .multiply:
            return try safeMultiply(lhs, rhs)
        case .divide:
            return try safeDivide(lhs, rhs)
        case .modulus:
            return try safeMod(lhs, rhs)
        }
    }

    private func safeAdd(_ lhs: Int, _ rhs: Int) throws -> Int {
        let result = lhs.addingReportingOverflow(rhs)
        guard !result.overflow else {
            throw CalcError.integerOverflow
        }
        return result.partialValue
    }

    private func safeSubtract(_ lhs: Int, _ rhs: Int) throws -> Int {
        let result = lhs.subtractingReportingOverflow(rhs)
        guard !result.overflow else {
            throw CalcError.integerOverflow
        }
        return result.partialValue
    }

    private func safeMultiply(_ lhs: Int, _ rhs: Int) throws -> Int {
        let result = lhs.multipliedReportingOverflow(by: rhs)
        guard !result.overflow else {
            throw CalcError.integerOverflow
        }
        return result.partialValue
    }

    private func safeDivide(_ lhs: Int, _ rhs: Int) throws -> Int {
        guard rhs != 0 else {
            throw CalcError.divisionByZero
        }

        if lhs == Int.min && rhs == -1 {
            throw CalcError.integerOverflow
        }

        return lhs / rhs
    }

    private func safeMod(_ lhs: Int, _ rhs: Int) throws -> Int {
        guard rhs != 0 else {
            throw CalcError.divisionByZero
        }

        return lhs % rhs
    }
}
