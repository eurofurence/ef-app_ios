// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "EventsWidgetLogic",
    defaultLocalization: "en",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "EventsWidgetLogic",
            targets: ["EventsWidgetLogic"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EventsWidgetLogic",
            dependencies: [],
            resources: [
                .process("Resources")
            ]
        ),
        
        .testTarget(
            name: "EventsWidgetLogicTests",
            dependencies: [
                .target(name: "EventsWidgetLogic")
            ]
        )
    ]
)
