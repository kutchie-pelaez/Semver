import Foundation

private let regex = try! NSRegularExpression(pattern: "[A-Za-z0-9-]+")

enum SemverIdentifier: CustomStringConvertible, Comparable {
    case string(String)
    case numeric(UInt)

    var isValid: Bool {
        switch self {
        case .string(let stringIdentifier):
            let stringLength = stringIdentifier.utf16.count
            let range = NSRange(location: 0, length: stringLength)
            let matches = regex.matches(in: stringIdentifier, range: range)

            return matches.first?.range(at: 0).length == stringLength

        case .numeric:
            return true
        }
    }

    // MARK: CustomStringConvertible

    var description: String {
        switch self {
        case .string(let stringIdentifier):
            return stringIdentifier

        case .numeric(let numericIdentifier):
            return String(numericIdentifier)
        }
    }

    // MARK: Comparable

    static func < (lhs: SemverIdentifier, rhs: SemverIdentifier) -> Bool {
        switch (lhs, rhs) {
        case (.string(let lhsStringIdentifier), .string(let rhsStringIdentifier)):
            return lhsStringIdentifier < rhsStringIdentifier

        case (.numeric(let lhsNumericIdentifier), .numeric(let rhsNumericIdentifier)):
            return lhsNumericIdentifier < rhsNumericIdentifier

        case (.string, .numeric):
            return false

        case (.numeric, .string):
            return true
        }
    }
}

extension Array where Element == SemverIdentifier {
    var identifiersDescription: String? {
        guard !isEmpty else {
            return nil
        }

        return map(\.description).joined(separator: ".")
    }
}
