public enum SemverParsingError: Error, Equatable {
    case invalidCoreFormat(String)
    case invalidPreReleaseFormat(String)
    case invalidBuildFormat(String)
    case emptyVersion
    case emptyCore
    case emptyPreRelease
    case emptyBuild
    case multipleBuilds
}

private enum MetadataType {
    case preRelease
    case build
}

struct SemverParser {
    func core(from string: String) throws -> (major: UInt, minor: UInt, patch: UInt) {
        guard !string.isEmpty else {
            throw SemverParsingError.emptyCore
        }

        let rawComponents = string
            .split(separator: ".", omittingEmptySubsequences: false)
            .map(String.init)
        let numericComponents = rawComponents
            .compactMap { rawComponent -> UInt? in
                guard let numericComponent = UInt(rawComponent) else {
                    return nil
                }

                if numericComponent > 0 && rawComponent.hasPrefix("0") {
                    return nil
                }

                return numericComponent
            }

        guard
            rawComponents.count == 3,
            numericComponents.count == 3
        else {
            throw SemverParsingError.invalidCoreFormat(string)
        }

        return (
            major: numericComponents[0],
            minor: numericComponents[1],
            patch: numericComponents[2]
        )
    }

    func buildIdentifiers(from string: String) throws -> [SemverIdentifier] {
        guard !string.isEmpty else {
            throw SemverParsingError.emptyBuild
        }

        return try identifiers(from: string, type: .build)
    }

    func preReleaseIdentifiers(from string: String) throws -> [SemverIdentifier] {
        guard !string.isEmpty else {
            throw SemverParsingError.emptyPreRelease
        }

        return try identifiers(from: string, type: .preRelease)
    }

    func rawComponents(from string: String) throws -> (core: String, preRelease: String?, build: String?) {
        guard !string.isEmpty else {
            throw SemverParsingError.emptyVersion
        }

        let buildSeparatorBasedSplits = string
            .split(separator: "+", omittingEmptySubsequences: false)
            .map(String.init)

        guard 1...2 ~= buildSeparatorBasedSplits.count else {
            throw SemverParsingError.multipleBuilds
        }

        let rawBuild = buildSeparatorBasedSplits[safe: 1]

        if rawBuild?.isEmpty == true {
            throw SemverParsingError.emptyBuild
        }

        let rawCoreAndPreRelease = try rawCoreAndPreRelease(from: buildSeparatorBasedSplits[0])

        return (
            core: rawCoreAndPreRelease.core,
            preRelease: rawCoreAndPreRelease.preRelease,
            build: rawBuild
        )
    }

    private func rawCoreAndPreRelease(from string: String) throws -> (core: String, preRelease: String?) {
        let preReleaseSeparatorBasedSplits = string
            .split(separator: "-", maxSplits: 1, omittingEmptySubsequences: false)
            .map(String.init)

        let rawPreRelease = preReleaseSeparatorBasedSplits[safe: 1]

        if rawPreRelease?.isEmpty == true {
            throw SemverParsingError.emptyPreRelease
        }

        return (
            core: preReleaseSeparatorBasedSplits[0],
            preRelease: rawPreRelease
        )
    }

    private func identifiers(from string: String, type: MetadataType) throws -> [SemverIdentifier] {
        let identifiers = string
            .split(separator: ".", omittingEmptySubsequences: false)
            .map(String.init)
            .map { stringIdentifier in
                if
                    let numericIdentifier = UInt(stringIdentifier),
                    !stringIdentifier.hasPrefix("0") &&
                    !stringIdentifier.hasPrefix("-")
                {
                    return SemverIdentifier.numeric(numericIdentifier)
                } else {
                    return SemverIdentifier.string(stringIdentifier)
                }
            }

        guard identifiers.allSatisfy({ $0.isValid }) else {
            switch type {
            case .preRelease:
                throw SemverParsingError.invalidPreReleaseFormat(string)

            case .build:
                throw SemverParsingError.invalidBuildFormat(string)
            }
        }

        return identifiers
    }
}

extension Collection {
    subscript(safe index: Index?) -> Element? {
        guard let index else { return nil }
        return indices.contains(index) ? self[index] : nil
    }
}
