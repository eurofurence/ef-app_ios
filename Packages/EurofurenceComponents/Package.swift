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
        
    ],
    targets: [
        .target(name: "EurofurenceComponentBase", dependencies: []),
        .testTarget(name: "EurofurenceComponentBaseTests", dependencies: [
            .target(name: "EurofurenceComponentBase")
        ]),
        
        .target(name: "XCTEurofurenceComponentBase", dependencies: [
            .target(name: "EurofurenceComponentBase")
        ]),
        
        .target(name: "EurofurenceComponents", dependencies: [
            .target(name: "EurofurenceComponentBase")
        ]),
        
        .testTarget(name: "EurofurenceComponentsTests", dependencies: [
            .target(name: "EurofurenceComponents")
        ])
    ]
)
