# Semver

Swift implementation of the [Semantic Versioning](http://semver.org/).

## Usage

```swift
import Semver

let version = Semver(1, 0, 0)
let versionWithPreReleaseAndBuild = try Semver(
    1, 0, 0,
    preRelease: "alpha",
    build: "build"
)
let versionFromString = try Semver("1.0.0-alpha+build")
```

`Semver` conforms to `CustomStringConvertible`, [`Comparable`](https://semver.org/#spec-item-11), `Hashable` and `Codable`:

```swift
/// version1 < version2 < version3 < version4
///
let version1 = try Semver("0.0.0")
let version2 = try Semver("1.0.0-alpha")
let version3 = try Semver("1.0.0")
let version4 = try Semver("2.0.0")

/// version == versionWithBuild
/// version.hashValue == versionWithBuild.hashValue
///
let version = try Semver("1.0.0")
let versionWithBuild = try Semver("1.0.0+build")
```

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/kutchie-pelaez/Semver.git", .upToNextMajor(from: "1.0.0"))
]
```

## License

Semver is released under the MIT license. See [LICENSE](LICENSE) for details.
