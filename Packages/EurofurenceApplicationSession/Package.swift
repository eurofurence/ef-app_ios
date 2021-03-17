// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EurofurenceApplicationSession",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "EurofurenceApplicationSession",
            targets: ["EurofurenceApplicationSession"]
        )
    ],
    dependencies: [
        .package(path: "../EurofurenceModel"),
        .package(path: "../TestUtilities"),
        
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: .init(7, 0, 0))
        )
    ],
    targets: [
        .target(
            name: "EurofurenceApplicationSession",
            dependencies: [
                .product(name: "EurofurenceModel", package: "EurofurenceModel"),
                .product(name: "FirebaseMessaging", package: "Firebase"),
                .product(name: "FirebaseRemoteConfig", package: "Firebase")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceApplicationSessionTests",
            dependencies: [
                .target(name: "EurofurenceApplicationSession"),
                .product(name: "XCTEurofurenceModel", package: "EurofurenceModel"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ]
        )
    ]
)
