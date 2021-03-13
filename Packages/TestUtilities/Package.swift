// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TestUtilities",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "TestUtilities",
            targets: ["TestUtilities"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TestUtilities",
            dependencies: []
        )
    ]
)
