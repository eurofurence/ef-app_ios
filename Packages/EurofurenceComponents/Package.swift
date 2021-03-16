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
            name: "XCTEurofurenceComponentBase",
            targets: ["XCTEurofurenceComponentBase"]
        )
    ],
    dependencies: [
        .package(path: "../TestUtilities"),
        .package(name: "Down", url: "https://github.com/johnxnguyen/Down", .upToNextMajor(from: "0.10.0"))
    ],
    targets: [
        .target(name: "EurofurenceComponentBase", dependencies: [
            .product(name: "Down", package: "Down")
        ]),
        
        .testTarget(name: "EurofurenceComponentBaseTests", dependencies: [
            .target(name: "EurofurenceComponentBase")
        ]),
        
        .target(name: "XCTEurofurenceComponentBase", dependencies: [
            .target(name: "EurofurenceComponentBase"),
            .product(name: "TestUtilities", package: "TestUtilities")
        ]),
        
        .target(name: "EurofurenceComponents", dependencies: [
            .target(name: "EurofurenceComponentBase")
        ]),
        
        .testTarget(name: "EurofurenceComponentsTests", dependencies: [
            .target(name: "EurofurenceComponents"),
            .target(name: "XCTEurofurenceComponentBase")
        ])
    ]
)
