// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EurofurenceComponents",
    products: [
        .library(
            name: "EurofurenceComponents",
            targets: ["EurofurenceComponents"]
        )
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "EurofurenceComponents",
            dependencies: []
        ),
        .testTarget(
            name: "EurofurenceComponentsTests",
            dependencies: ["EurofurenceComponents"]
        )
    ]
)
