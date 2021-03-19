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
                .product(name: "EurofurenceApplicationSession", package: "EurofurenceApplicationSession"),
                
                .product(name: "EventFeedbackComponent", package: "EurofurenceComponents"),
                .product(name: "DealersComponent", package: "EurofurenceComponents"),
                .product(name: "DealerComponent", package: "EurofurenceComponents"),
                .product(name: "PreloadComponent", package: "EurofurenceComponents"),
                .product(name: "TutorialComponent", package: "EurofurenceComponents"),
                .product(name: "ContentController", package: "EurofurenceComponents")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceApplicationTests",
            dependencies: [
                .target(name: "EurofurenceApplication"),
                .product(name: "XCTEurofurenceModel", package: "EurofurenceModel"),
                .product(name: "XCTComponentBase", package: "EurofurenceComponents"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
