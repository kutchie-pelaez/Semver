// https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions

private let maximumRecursionLevelForIndirectCases = 2

enum ValidSemver {
    case versionCore(VersionCore)
    case versionCorePreRelease(VersionCore, PreRelease)
    case versionCoreBuild(VersionCore, Build)
    case versionCorePreReleaseBuild(VersionCore, PreRelease, Build)

    static var random: Self {
        [
            .versionCore(.random),
            .versionCorePreRelease(.random, .random),
            .versionCoreBuild(.random, .random),
            .versionCorePreReleaseBuild(.random, .random, .random),
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .versionCore(versionCore):
            return versionCore.rawValue
        case let .versionCorePreRelease(versionCore, preRelease):
            return versionCore.rawValue
                + "-"
                + preRelease.rawValue
        case let .versionCoreBuild(versionCore, build):
            return versionCore.rawValue
                + "+"
                + build.rawValue
        case let .versionCorePreReleaseBuild(versionCore, preRelease, build):
            return versionCore.rawValue
                + "-"
                + preRelease.rawValue
                + "+"
                + build.rawValue
        }
    }
}

enum VersionCore {
    case majorMinorPatch(Major, Minor, Patch)

    static var random: Self {
        [.majorMinorPatch(.random, .random, .random)].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .majorMinorPatch(major, minor, patch):
            return major.rawValue
                + "."
                + minor.rawValue
                + "."
                + patch.rawValue
        }
    }
}

enum Major {
    case numericIdentifier(NumericIdentifier)

    static var random: Self {
        [.numericIdentifier(.random)].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .numericIdentifier(numericIdentifier):
            return numericIdentifier.rawValue
        }
    }
}

enum Minor {
    case numericIdentifier(NumericIdentifier)

    static var random: Self {
        [.numericIdentifier(.random)].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .numericIdentifier(numericIdentifier):
            return numericIdentifier.rawValue
        }
    }
}

enum Patch {
    case numericIdentifier(NumericIdentifier)

    static var random: Self {
        [.numericIdentifier(.random)].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .numericIdentifier(numericIdentifier):
            return numericIdentifier.rawValue
        }
    }
}

enum PreRelease {
    case dotSeparatedPreReleaseIdentifiers(DotSeparatedPreReleaseIdentifiers)

    static var random: Self {
        [.dotSeparatedPreReleaseIdentifiers(.random)].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .dotSeparatedPreReleaseIdentifiers(dotSeparatedPreReleaseIdentifiers):
            return dotSeparatedPreReleaseIdentifiers.rawValue
        }
    }
}

enum DotSeparatedPreReleaseIdentifiers {
    case preReleaseIdentifier(PreReleaseIdentifier)
    indirect case preReleaseIdentifierDotSeparatedPreReleaseIdentifiers(
        PreReleaseIdentifier,
        DotSeparatedPreReleaseIdentifiers
    )

    static var random: Self {
        random()
    }

    private static func random(
        _ currentLevel: Int = 0,
        _ maxLevel: Int = .random(in: 0...maximumRecursionLevelForIndirectCases)
    ) -> Self {
        let preReleaseIdentifier = PreReleaseIdentifier.random

        if currentLevel == maxLevel {
            return .preReleaseIdentifier(preReleaseIdentifier)
        } else {
            return .preReleaseIdentifierDotSeparatedPreReleaseIdentifiers(
                preReleaseIdentifier,
                random(currentLevel + 1, maxLevel)
            )
        }
    }

    var rawValue: String {
        switch self {
        case let .preReleaseIdentifier(preReleaseIdentifier):
            return preReleaseIdentifier.rawValue
        case let .preReleaseIdentifierDotSeparatedPreReleaseIdentifiers(
            preReleaseIdentifier,
            dotSeparatedPreReleaseIdentifiers
        ):
            return preReleaseIdentifier.rawValue + "." + dotSeparatedPreReleaseIdentifiers.rawValue
        }
    }
}

enum Build {
    case dotSeparatedBuildIdentifiers(DotSeparatedBuildIdentifiers)

    static var random: Self {
        [.dotSeparatedBuildIdentifiers(.random)].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .dotSeparatedBuildIdentifiers(dotSeparatedBuildIdentifiers):
            return dotSeparatedBuildIdentifiers.rawValue
        }
    }
}

enum DotSeparatedBuildIdentifiers {
    case buildIdentifier(BuildIdentifier)
    indirect case buildIdentifierDotSeparatedBuildIdentifiers(
        BuildIdentifier,
        DotSeparatedBuildIdentifiers
    )

    static var random: Self {
        random()
    }

    private static func random(
        _ currentLevel: Int = 0,
        _ maxLevel: Int = .random(in: 0...maximumRecursionLevelForIndirectCases)
    ) -> Self {
        let buildIdentifier = BuildIdentifier.random

        if currentLevel == maxLevel {
            return .buildIdentifier(buildIdentifier)
        } else {
            return .buildIdentifierDotSeparatedBuildIdentifiers(
                buildIdentifier,
                random(currentLevel + 1, maxLevel)
            )
        }
    }

    var rawValue: String {
        switch self {
        case let .buildIdentifier(buildIdentifier):
            return buildIdentifier.rawValue
        case let .buildIdentifierDotSeparatedBuildIdentifiers(buildIdentifier, dotSeparatedBuildIdentifiers):
            return buildIdentifier.rawValue + "." + dotSeparatedBuildIdentifiers.rawValue
        }
    }
}

enum PreReleaseIdentifier {
    case alphanumericIdentifier(AlphanumericIdentifier)
    case numericIdentifier(NumericIdentifier)

    static var random: Self {
        [
            .alphanumericIdentifier(.random),
            .numericIdentifier(.random)
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .alphanumericIdentifier(alphanumericIdentifier):
            return alphanumericIdentifier.rawValue
        case let .numericIdentifier(numericIdentifier):
            return numericIdentifier.rawValue
        }
    }
}

enum BuildIdentifier {
    case alphanumericIdentifier(AlphanumericIdentifier)
    case digits(Digits)

    static var random: Self {
        [
            .alphanumericIdentifier(.random),
            .digits(.random)
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .alphanumericIdentifier(alphanumericIdentifier):
            return alphanumericIdentifier.rawValue
        case let .digits(digits):
            return digits.rawValue
        }
    }
}

enum AlphanumericIdentifier {
    case nonDigit(NonDigit)
    case nonDigitIdentifierCharacters(NonDigit, IdentifierCharacters)
    case identifierCharactersNonDigitIdentifierCharacters(IdentifierCharacters, NonDigit, IdentifierCharacters)

    static var random: Self {
        [
            .nonDigit(.random),
            .nonDigitIdentifierCharacters(.random, .random),
            .identifierCharactersNonDigitIdentifierCharacters(.random, .random, .random)
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .nonDigit(nonDigit):
            return nonDigit.rawValue
        case let .nonDigitIdentifierCharacters(nonDigit, identifierCharacters):
            return nonDigit.rawValue + identifierCharacters.rawValue
        case let .identifierCharactersNonDigitIdentifierCharacters(
            firstIdentifierCharacters,
            nonDigit,
            secondIdentifierCharacters
        ):
            return firstIdentifierCharacters.rawValue
                + nonDigit.rawValue
                + secondIdentifierCharacters.rawValue
        }
    }
}

enum NumericIdentifier {
    case zero
    case positiveDigit(PositiveDigit)
    case positiveDigitDigits(PositiveDigit, Digits)

    static var random: Self {
        [
            .zero,
            .positiveDigit(.random),
            .positiveDigitDigits(.random, .random)
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case .zero:
            return "0"
        case let .positiveDigit(positiveDigit):
            return positiveDigit.rawValue
        case let .positiveDigitDigits(positiveDigit, digits):
            return positiveDigit.rawValue + digits.rawValue
        }
    }
}

enum IdentifierCharacters {
    case identifierCharacter(IdentifierCharacter)
    indirect case identifierCharacterIdentifierCharacters(
        IdentifierCharacter,
        IdentifierCharacters
    )

    static var random: Self {
        random()
    }

    private static func random(
        _ currentLevel: Int = 0,
        _ maxLevel: Int = .random(in: 0...maximumRecursionLevelForIndirectCases)
    ) -> Self {
        let identifierCharacter = IdentifierCharacter.random

        if currentLevel == maxLevel {
            return .identifierCharacter(identifierCharacter)
        } else {
            return .identifierCharacterIdentifierCharacters(
                identifierCharacter,
                random(currentLevel + 1, maxLevel)
            )
        }
    }

    var rawValue: String {
        switch self {
        case let .identifierCharacter(identifierCharacter):
            return identifierCharacter.rawValue
        case let .identifierCharacterIdentifierCharacters(identifierCharacter, identifierCharacters):
            return identifierCharacter.rawValue + identifierCharacters.rawValue
        }
    }
}

enum IdentifierCharacter {
    case digit(Digit)
    case nonDigit(NonDigit)

    static var random: Self {
        [
            .digit(.random),
            .nonDigit(.random)
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case let .digit(digit):
            return digit.rawValue
        case let .nonDigit(nonDigit):
            return nonDigit.rawValue
        }
    }
}

enum NonDigit {
    case hyphen
    case letter(Letter)

    static var random: Self {
        [
            .hyphen,
            .letter(.random)
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case .hyphen:
            return "-"
        case let .letter(letter):
            return letter.rawValue
        }
    }
}

enum Digits {
    case digit(Digit)
    indirect case digitDigits(Digit, Digits)

    static var random: Self {
        random()
    }

    private static func random(
        _ currentLevel: Int = 0,
        _ maxLevel: Int = .random(in: 0...maximumRecursionLevelForIndirectCases)
    ) -> Self {
        let digit = Digit.random

        if currentLevel == maxLevel {
            return .digit(digit)
        } else {
            return .digitDigits(
                digit,
                random(currentLevel + 1, maxLevel)
            )
        }
    }

    var rawValue: String {
        switch self {
        case let .digit(digit):
            return digit.rawValue
        case let .digitDigits(digit, digits):
            return digit.rawValue + digits.rawValue
        }
    }
}

enum Digit {
    case zero
    case positiveDigit(PositiveDigit)

    static var random: Self {
        [
            .zero,
            .positiveDigit(.random)
        ].randomElement()!
    }

    var rawValue: String {
        switch self {
        case .zero:
            return "0"
        case let .positiveDigit(positiveDigit):
            return positiveDigit.rawValue
        }
    }
}

enum PositiveDigit: String, CaseIterable {
    case one = "1", two = "2", three = "3"
    case four = "4", five = "5", six = "6"
    case seven = "7", eight = "8", nine = "9"

    static var random: Self {
        allCases.randomElement()!
    }
}

enum Letter: String, CaseIterable {
    case A, B, C, D, E, F, G, H, I, J
    case K, L, M, N, O, P, Q, R, S, T
    case U, V, W, X, Y, Z
    case a, b, c, d, e, f, g, h, i, j
    case k, l, m, n, o, p, q, r, s, t
    case u, v, w, x, y, z

    static var random: Self {
        allCases.randomElement()!
    }
}
