// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lancer",
    platforms: [.macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Lancer",
            targets: ["Lancer"]),
    ],
    dependencies: [
        
        .package(url: "https://github.com/kareman/SwiftShell", from: "5.0.0"),
        .package(url: "https://github.com/Mechagnome/Alliances", from: "1.0.0"),
        .package(url: "https://github.com/linhay/Stem.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Lancer",
            dependencies: [
                .product(name: "SwiftShell", package: "SwiftShell"),
                .product(name: "Stem", package: "Stem"),
                .product(name: "Alliances", package: "Alliances")
            ]),
        .testTarget(
            name: "LancerTests",
            dependencies: ["Lancer",
                           .product(name: "Stem", package: "Stem")]),
    ]
)
