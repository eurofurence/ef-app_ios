// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "EurofurenceModel",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "EurofurenceModel",
            targets: ["EurofurenceModel"]
        ),
        
        .library(
            name: "EurofurenceModelTestDoubles",
            targets: ["EurofurenceModelTestDoubles"]
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
            name: "EurofurenceModelTestDoubles",
            dependencies: [
                .target(name: "EurofurenceModel"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceModelTests",
            dependencies: [
                .target(name: "EurofurenceModel"),
                .target(name: "EurofurenceModelTestDoubles"),
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
                .target(name: "EurofurenceModelTestDoubles"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ]
        )
    ]
)
