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
        .package(name: "PTCGBattlePokemon", url: "https://github.com/evdwarf/ptcg-battle-pokemon", from: "0.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PTCGPlayerBoard",
            dependencies: ["PTCGBattlePokemon"]),
        .testTarget(
            name: "PTCGPlayerBoardTests",
            dependencies: ["PTCGPlayerBoard"]),
    ]
)
