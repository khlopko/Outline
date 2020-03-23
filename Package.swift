// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Outline",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "Outline", targets: ["Outline"])
    ],
    targets: [
        .target(name: "Outline", path: "Sources"),
        .testTarget(name: "OutlineTests", dependencies: ["Outline"], path: "Tests")
    ],
    swiftLanguageVersions: [.v5])
