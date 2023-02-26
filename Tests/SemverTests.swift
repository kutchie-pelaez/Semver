import Semver
import XCTest

final class SemverTests: XCTestCase {
    func testRandomValidVersions() {
        for _ in 0..<100 {
            do {
                let rawVersion = ValidSemver.random.rawValue
                let version = try Semver(rawVersion)
                XCTAssertEqual(version.description, rawVersion)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testInvalidVersions() {
        for (rawVersions, parsingError) in invalidVersionsAndErrors {
            for rawVersion in rawVersions {
                XCTAssertThrowsError(try Semver(rawVersion), rawVersion) {
                    XCTAssertEqual($0 as! SemverParsingError, parsingError, rawVersion)
                }
            }
        }

        for invalidCoreFormatVersion in invalidCoreFormatVersions {
            XCTAssertThrowsError(try Semver(invalidCoreFormatVersion), invalidCoreFormatVersion) {
                guard case SemverParsingError.invalidCoreFormat = $0 else {
                    XCTFail(invalidCoreFormatVersion)
                    return
                }
            }
        }

        for invalidPreReleaseFormatVersion in invalidPreReleaseFormatVersions {
            XCTAssertThrowsError(try Semver(invalidPreReleaseFormatVersion), invalidPreReleaseFormatVersion) {
                guard case SemverParsingError.invalidPreReleaseFormat = $0 else {
                    XCTFail(invalidPreReleaseFormatVersion)
                    return
                }
            }
        }

        for invalidBuildFormatVersion in invalidBuildFormatVersions {
            XCTAssertThrowsError(try Semver(invalidBuildFormatVersion), invalidBuildFormatVersion) {
                guard case SemverParsingError.invalidBuildFormat = $0 else {
                    XCTFail(invalidBuildFormatVersion)
                    return
                }
            }
        }
    }

    func testVersionsComparing() {
        do {
            let sortingResult = try sortedVersions
                .map { try Semver($0) }
                .sorted()
                .map(\.description)
            XCTAssertEqual(sortingResult, sortedVersions)
        } catch {
            XCTFail()
        }
    }
}

private let invalidVersionsAndErrors: [([String], SemverParsingError)] = [
    ([""], .emptyVersion),
    (["-alpha", "-alpha+1", "+1"], .emptyCore),
    (["1.0.0-", "1.0.0-+1"], .emptyPreRelease),
    (["1.0.0+", "1.0.0-alpha+"], .emptyBuild),
    (["1.0.0+1+2", "1.0.0-alpha+1+2"], .multipleBuilds)
]

private let invalidCoreFormatVersions = [
    "1", ".1", "1.", ".", "1.1.1.1", "1.1.1.1.1",
    "1.1", "1.1.", "1..1", ".1.1", "1..", "..",
    "1.1-alpha", "1.1.-alpha", "1.1.1.-alpha",
    "1.1+42", "1.1.+42",
    "01.1.1", "001.1.1", "1.01.1", "1.001.1", "1.1.01", "1.1.001",
    "a.b.c", "1.a.b", "1.1.a", "1.a.1", "a.1.1",
    "*.1.1", "1.*.1", "1.1.^", "1_000_000_000.1.1", "1.1.1 "
]

private let invalidPreReleaseFormatVersions = [
    "1.1.1-alpha..0", "1.1.1- 1", "1.1.1-a ",
    "1.1.1-*", "1.1.1-alpha.#", "1.1.1-1.^.1",
    "1.1.1-(1)", "1.1.1-1_000_000_000", "1.2.3-naïve",
    "1.2.3-ж.foo"
]

private let invalidBuildFormatVersions = [
    "1.1.1+a..1", "1.1.1+h*23", "1.2.3+🤨.foo",
    "1.1.1-alpha.0+a#1", "1.1.1+ ", "1.1.1+Hello World"
]

private let sortedVersions = [
    "0.0.1-alpha.0",
    "0.0.1",
    "0.0.2-alpha",
    "0.0.2-alpha.0",
    "0.0.2-alpha.0.1",
    "0.0.2",
    "0.0.3-aaa",
    "0.0.3-aaa.2",
    "0.0.3-aaa.11",
    "0.0.3-alpha.1",
    "0.1.0-beta.2",
    "0.1.0-beta.3",
    "0.1.0-rc.1",
    "0.1.0",
    "1.0.0-1",
    "1.0.0-11",
    "1.0.0-alpha.0",
    "1.0.0",
    "1.0.1",
    "1.1.0",
    "1.2.0",
    "2.0.0-1",
    "2.0.0--1",
    "2.0.0--2",
    "2.0.0-alpha.0"
]
