// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EurofurenceApplication",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "EurofurenceApplication",
            targets: ["EurofurenceApplication"]
        )
    ],
    dependencies: [
        .package(path: "../EurofurenceModel"),
        .package(path: "../EurofurenceComponents"),
        .package(path: "../EurofurenceApplicationSession"),
        .package(path: "../TestUtilities")
    ],
    targets: [
        .target(
            name: "EurofurenceApplication",
            dependencies: [
                .product(name: "EurofurenceModel", package: "EurofurenceModel"),
                .product(name: "EurofurenceComponents", package: "EurofurenceComponents"),
                .product(name: "EurofurenceApplicationSession", package: "EurofurenceApplicationSession")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceApplicationTests",
            dependencies: [
                .target(name: "EurofurenceApplication"),
                .product(name: "EurofurenceModelTestDoubles", package: "EurofurenceModel"),
                .product(name: "XCTComponentBase", package: "EurofurenceComponents"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
