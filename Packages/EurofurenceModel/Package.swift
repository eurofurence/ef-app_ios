// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "EurofurenceModel",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "EurofurenceModel",
            targets: ["EurofurenceModel"]
        ),
        
        .library(
            name: "XCTEurofurenceModel",
            targets: ["XCTEurofurenceModel"]
        )
    ],
    dependencies: [
        .package(path: "../TestUtilities")
    ],
    targets: [
        .target(
            name: "EurofurenceModel",
            dependencies: []
        ),
        
        .target(
            name: "XCTEurofurenceModel",
            dependencies: [
                .target(name: "EurofurenceModel"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceModelTests",
            dependencies: [
                .target(name: "EurofurenceModel"),
                .target(name: "XCTEurofurenceModel"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceModelAdapterTests",
            dependencies: [
                .target(name: "EurofurenceModel"),
                .target(name: "XCTEurofurenceModel"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ]
        )
    ]
)
