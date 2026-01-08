// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NoodlesThemeStandard",
    platforms: [
        .iOS(.v18),
        .visionOS(.v1),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "NoodlesThemeStandard",
            targets: ["NoodlesThemeStandard"]
        ),
    ],
    dependencies: [
        .package(name: "NoodlesDesignSystem", path: "../NoodlesDesignSystem"),
        .package(name: "FontInter", path: "../FontInter")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "NoodlesThemeStandard",
            dependencies: [
                .byName(name: "NoodlesDesignSystem"),
                .byName(name: "FontInter"),
            ],
        ),

    ]
)
