// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "EurofurenceComponents",
    defaultLocalization: "en",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "TutorialComponent", targets: ["TutorialComponent"]),
        .library(name: "PreloadComponent", targets: ["PreloadComponent"]),
        .library(name: "ContentController", targets: ["ContentController"]),
        .library(name: "ScheduleComponent", targets: ["ScheduleComponent"]),
        .library(name: "EventDetailComponent", targets: ["EventDetailComponent"]),
        .library(name: "EventFeedbackComponent", targets: ["EventFeedbackComponent"]),
        .library(name: "DealersComponent", targets: ["DealersComponent"]),
        .library(name: "DealerComponent", targets: ["DealerComponent"]),
            
        .library(name: "XCTComponentBase", targets: ["XCTComponentBase"]),
        .library(name: "XCTScheduleComponent", targets: ["XCTScheduleComponent"]),
        .library(name: "XCTEventDetailComponent", targets: ["XCTEventDetailComponent"])
    ],
    dependencies: [
        .package(path: "../EurofurenceModel"),
        .package(path: "../TestUtilities"),
        .package(name: "Down", url: "https://github.com/johnxnguyen/Down", .upToNextMajor(from: "0.10.0"))
    ],
    targets: [
        .target(name: "ComponentBase", dependencies: [
            .product(name: "Down", package: "Down"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .target(name: "XCTComponentBase", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "TestUtilities", package: "TestUtilities")
        ]),
        
        .testTarget(name: "ComponentBaseTests", dependencies: [
            .target(name: "ComponentBase"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ], resources: [
            .process("Resources")
        ]),
        
        // MARK: Content Controller
        
        .target(name: "ContentController", dependencies: [
            .target(name: "ComponentBase"),
            .target(name: "TutorialComponent"),
            .target(name: "PreloadComponent")
        ]),
        
        .testTarget(name: "ContentControllerTests", dependencies: [
            .target(name: "ContentController"),
            .target(name: "TutorialComponent"),
            .target(name: "PreloadComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Tutorial
        
        .target(name: "TutorialComponent", dependencies: [
            .target(name: "ComponentBase")
        ]),
        
        .testTarget(name: "TutorialComponentTests", dependencies: [
            .target(name: "TutorialComponent"),
            .target(name: "XCTComponentBase")
        ]),
        
        // MARK: Preload
        
        .target(name: "PreloadComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "PreloadComponentTests", dependencies: [
            .target(name: "PreloadComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Schedule
        
        .target(name: "ScheduleComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .target(name: "XCTScheduleComponent", dependencies: [
            .target(name: "ScheduleComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "ScheduleComponentTests", dependencies: [
            .target(name: "ScheduleComponent"),
            .target(name: "XCTComponentBase"),
            .target(name: "XCTScheduleComponent"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Event Detail
        
        .target(name: "EventDetailComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .target(name: "XCTEventDetailComponent", dependencies: [
            .target(name: "EventDetailComponent"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "EventDetailComponentTests", dependencies: [
            .target(name: "EventDetailComponent"),
            .target(name: "XCTComponentBase"),
            .target(name: "XCTEventDetailComponent"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Event Feedback
        
        .target(name: "EventFeedbackComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "EventFeedbackComponentTests", dependencies: [
            .target(name: "EventFeedbackComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Dealers
        
        .target(name: "DealersComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "DealersComponentTests", dependencies: [
            .target(name: "DealersComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Dealer
        
        .target(name: "DealerComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "DealerComponentTests", dependencies: [
            .target(name: "DealerComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ])
        
    ]
)
