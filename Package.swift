// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "FloatingFilter",
    platforms: [
        .macOS(.v10_13),
    ],
    products: [
        .library(
            name: "FloatingFilter",
            targets: ["FloatingFilter"]),
    ],
    targets: [
        .target(
            name: "FloatingFilter"),
        .testTarget(
            name: "FloatingFilterTests",
            dependencies: ["FloatingFilter"]),
    ]
)
