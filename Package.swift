// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Semver",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "Semver", targets: ["Semver"])
    ],
    targets: [
        .target(name: "Semver", path: "Sources"),
        .testTarget(name: "SemverTests", dependencies: [
            .target(name: "Semver")
        ], path: "Tests")
    ]
)
