import Foundation

/// Supported operators for the calculator language.
enum OperatorToken: String {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    case modulus = "%"

    var isAdditive: Bool {
        switch self {
        case .add, .subtract:
            return true
        default:
            return false
        }
    }

    var isMultiplicative: Bool {
        switch self {
        case .multiply, .divide, .modulus:
            return true
        default:
            return false
        }
    }
}
