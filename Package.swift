// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VisualKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "VisualKit",
            targets: ["VisualKit"]),
    ],
    targets: [
        .target(
            name: "VisualKit",
            resources: [
                .copy("ViewModifiers/Shaders.metal")]
        )
    ]
)
