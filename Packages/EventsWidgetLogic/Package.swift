// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EventsWidgetLogic",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(
            name: "EventsWidgetLogic",
            targets: ["EventsWidgetLogic"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EventsWidgetLogic",
            dependencies: []
        ),
        
        .testTarget(
            name: "EventsWidgetLogicTests",
            dependencies: [
                .target(name: "EventsWidgetLogic")
            ]
        ),
    ]
)
