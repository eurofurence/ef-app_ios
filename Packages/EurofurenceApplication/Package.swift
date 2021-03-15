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
        .package(path: "../TestUtilities"),
        
        .package(name: "Down", url: "https://github.com/johnxnguyen/Down", .upToNextMajor(from: "0.10.0"))
    ],
    targets: [
        .target(
            name: "EurofurenceApplication",
            dependencies: [
                .product(name: "EurofurenceModel", package: "EurofurenceModel"),
                .product(name: "EurofurenceComponents", package: "EurofurenceComponents"),
                .product(name: "EurofurenceApplicationSession", package: "EurofurenceApplicationSession"),
                
                .product(name: "Down", package: "Down")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceApplicationTests",
            dependencies: [
                .target(name: "EurofurenceApplication"),
                .product(name: "EurofurenceModelTestDoubles", package: "EurofurenceModel"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
