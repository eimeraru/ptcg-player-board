// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PTCGPlayerBoard",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PTCGPlayerBoard",
            targets: ["PTCGPlayerBoard"]),
    ],
    dependencies: [
        .package(name: "PTCGCard",
                 url: "https://github.com/evdwarf/ptcg-card",
                 from: "0.0.9"),
        .package(name: "PTCGSpecialConditions",
                 url: "https://github.com/evdwarf/ptcg-special-conditions",
                 from: "0.0.4"),
    ],
    targets: [
        .target(
            name: "PTCGPlayerBoard",
            dependencies: ["PTCGCard", "PTCGSpecialConditions"]),
        .testTarget(
            name: "PTCGPlayerBoardTests",
            dependencies: ["PTCGPlayerBoard"]),
    ]
)
