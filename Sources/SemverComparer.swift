import Foundation

struct SemverComparer {
    func compareVersions(_ lhs: Semver, _ rhs: Semver) -> ComparisonResult {
        let versionCoresComparisonResult = compareVersionCores(lhs, rhs)
        let lhsPreReleaseIdentifiers = lhs.preReleaseIdentifiers
        let rhsPreReleaseIdentifiers = rhs.preReleaseIdentifiers

        guard versionCoresComparisonResult == .orderedSame else {
            return versionCoresComparisonResult
        }

        if let lhsPreReleaseIdentifiers, let rhsPreReleaseIdentifiers {
            let preReleaseIdentifiersComparisonResult = compareIdentifiers(
                lhsPreReleaseIdentifiers,
                rhsPreReleaseIdentifiers
            )

            if versionCoresComparisonResult == .orderedSame {
                return preReleaseIdentifiersComparisonResult
            } else {
                return versionCoresComparisonResult
            }
        } else if lhsPreReleaseIdentifiers != nil {
            return .orderedAscending
        } else if rhsPreReleaseIdentifiers != nil {
            return .orderedDescending
        } else {
            return .orderedSame
        }
    }

    private func compareVersionCores(_ lhs: Semver, _ rhs: Semver) -> ComparisonResult {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major ? .orderedAscending : .orderedDescending
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor ? .orderedAscending : .orderedDescending
        } else if lhs.patch != rhs.patch {
            return lhs.patch < rhs.patch ? .orderedAscending : .orderedDescending
        } else {
            return .orderedSame
        }
    }

    private func compareIdentifiers(_ lhs: [SemverIdentifier], _ rhs: [SemverIdentifier]) -> ComparisonResult {
        guard lhs != rhs else { return .orderedSame }

        for index in 0..<max(lhs.count, rhs.count) {
            let lhsIdentifier = lhs[safe: index]
            let rhsIdentifier = rhs[safe: index]

            if let lhsIdentifier, let rhsIdentifier {
                guard lhsIdentifier != rhsIdentifier else { continue }

                return lhsIdentifier < rhsIdentifier ? .orderedAscending : .orderedDescending
            } else if lhsIdentifier != nil {
                return .orderedDescending
            } else if rhsIdentifier != nil {
                return .orderedAscending
            }
        }

        fatalError()
    }
}
