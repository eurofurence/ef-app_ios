// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "TestUtilities",
    platforms: [.iOS(.v13)],
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
