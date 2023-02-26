private let parser = SemverParser()
private let comparer = SemverComparer()

public struct Semver: CustomStringConvertible, Comparable, Hashable, Codable {
    public let major: UInt
    public let minor: UInt
    public let patch: UInt

    let preReleaseIdentifiers: [SemverIdentifier]?
    let buildIdentifiers: [SemverIdentifier]?

    public var preRelease: String? {
        preReleaseIdentifiers?.identifiersDescription
    }

    public var build: String? {
        buildIdentifiers?.identifiersDescription
    }

    public init(_ major: UInt, _ minor: UInt, _ patch: UInt) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preReleaseIdentifiers = nil
        self.buildIdentifiers = nil
    }

    public init(_ major: UInt, _ minor: UInt, _ patch: UInt, preRelease: String? = nil, build: String? = nil) throws {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preReleaseIdentifiers = try preRelease.map(parser.preReleaseIdentifiers)
        self.buildIdentifiers = try build.map(parser.buildIdentifiers)
    }

    public init(_ string: String) throws {
        let (rawCore, rawPreRelease, rawBuild) = try parser.rawComponents(from: string)
        let (major, minor, patch) = try parser.core(from: rawCore)
        try self.init(major, minor, patch, preRelease: rawPreRelease, build: rawBuild)
    }

    // MARK: CustomStringConvertible

    public var description: String {
        let core = "\(major).\(minor).\(patch)"
        let coreAndPreRelease = [core, preRelease]
            .compactMap { $0 }
            .joined(separator: "-")
        let corePreReleaseAndBuild = [coreAndPreRelease, build]
            .compactMap { $0 }
            .joined(separator: "+")
        return corePreReleaseAndBuild
    }

    // MARK: Equtable

    public static func == (lhs: Semver, rhs: Semver) -> Bool {
        comparer.compareVersions(lhs, rhs) == .orderedSame
    }

    // MARK: Comparable

    public static func < (lhs: Semver, rhs: Semver) -> Bool {
        comparer.compareVersions(lhs, rhs) == .orderedAscending
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        hasher.combine(preRelease)
    }

    // MARK: Decodable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawVersion = try container.decode(String.self)
        self = try Semver(rawVersion)
    }

    // MARK: Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
