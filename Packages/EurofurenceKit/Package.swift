// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "EurofurenceKit",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8)],
    products: [
        .library(
            name: "EurofurenceKit",
            targets: ["EurofurenceKit", "EurofurenceWebAPI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: .init(8, 0, 0))
        )
    ],
    targets: [
        .target(
            name: "EurofurenceWebAPI",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
            ]
        ),
        
        .target(
            name: "EurofurenceKit",
            dependencies: [
                .target(name: "EurofurenceWebAPI"),
                .product(name: "Logging", package: "swift-log")
            ],
            resources: [
                .process("Preview Content")
            ]
        ),
        
        .target(
            name: "XCTAsyncAssertions",
            dependencies: []
        ),
        
        .testTarget(
            name: "EurofurenceWebAPITests",
            dependencies: [
                .target(name: "EurofurenceWebAPI"),
                .target(name: "XCTAsyncAssertions")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceKitTests",
            dependencies: [
                .target(name: "EurofurenceKit"),
                .target(name: "XCTAsyncAssertions")
            ],
            resources: [
                .process("Remote Responses/JSON")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceKitAcceptanceTests",
            dependencies: [
                .target(name: "EurofurenceKit"),
                .target(name: "XCTAsyncAssertions")
            ]
        )
    ]
)
