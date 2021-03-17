// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EurofurenceComponents",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "EurofurenceComponents",
            targets: ["EurofurenceComponents"]
        ),
        
        .library(
            name: "XCTComponentBase",
            targets: ["XCTComponentBase"]
        )
    ],
    dependencies: [
        .package(path: "../TestUtilities"),
        .package(name: "Down", url: "https://github.com/johnxnguyen/Down", .upToNextMajor(from: "0.10.0"))
    ],
    targets: [
        .target(name: "ComponentBase", dependencies: [
            .product(name: "Down", package: "Down")
        ]),
        
        .target(name: "XCTComponentBase", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "TestUtilities", package: "TestUtilities")
        ]),
        
        .testTarget(name: "ComponentBaseTests", dependencies: [
            .target(name: "ComponentBase"),
            .target(name: "XCTComponentBase")
        ]),
        
        .target(name: "EurofurenceComponents", dependencies: [
            .target(name: "ComponentBase")
        ]),
        
        .testTarget(name: "EurofurenceComponentsTests", dependencies: [
            .target(name: "EurofurenceComponents"),
            .target(name: "XCTComponentBase")
        ])
    ]
)
