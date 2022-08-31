// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "EurofurenceKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v12), .watchOS(.v8)],
    products: [
        .library(
            name: "EurofurenceKit",
            targets: ["EurofurenceKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "EurofurenceKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceKitTests",
            dependencies: [
                .target(name: "EurofurenceKit")
            ],
            resources: [
                .process("Remote Responses/EF26 Full Sync Response/EF26_Full_Sync_Response.json"),
                .process("Remote Responses/EF26 Corrupt Response/EF26_Corrupt_Sync_Response.json")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceKitAcceptanceTests",
            dependencies: [
                .target(name: "EurofurenceKit")
            ]
        )
    ]
)
