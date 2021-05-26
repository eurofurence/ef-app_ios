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
        .library(name: "EventsJourney", targets: ["EventsJourney"]),
        .library(name: "EventDetailComponent", targets: ["EventDetailComponent"]),
        .library(name: "EventFeedbackComponent", targets: ["EventFeedbackComponent"]),
        .library(name: "DealersComponent", targets: ["DealersComponent"]),
        .library(name: "DealerComponent", targets: ["DealerComponent"]),
        .library(name: "KnowledgeJourney", targets: ["KnowledgeJourney"]),
        .library(name: "KnowledgeGroupsComponent", targets: ["KnowledgeGroupsComponent"]),
        .library(name: "KnowledgeGroupComponent", targets: ["KnowledgeGroupComponent"]),
        .library(name: "KnowledgeDetailComponent", targets: ["KnowledgeDetailComponent"]),
            
        .library(name: "XCTComponentBase", targets: ["XCTComponentBase"]),
        .library(name: "XCTScheduleComponent", targets: ["XCTScheduleComponent"]),
        .library(name: "XCTDealerComponent", targets: ["XCTDealerComponent"]),
        .library(name: "XCTEventFeedbackComponent", targets: ["XCTEventFeedbackComponent"]),
        .library(name: "XCTEventDetailComponent", targets: ["XCTEventDetailComponent"]),
        .library(name: "XCTKnowledgeGroupComponent", targets: ["XCTKnowledgeGroupComponent"]),
        .library(name: "XCTKnowledgeDetailComponent", targets: ["XCTKnowledgeDetailComponent"])
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
        
        // MARK: Events Journey
        
        .target(name: "EventsJourney", dependencies: [
            .target(name: "ScheduleComponent"),
            .target(name: "EventDetailComponent"),
            .target(name: "EventFeedbackComponent"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "EventsJourneyTests", dependencies: [
            .target(name: "EventsJourney"),
            .target(name: "XCTScheduleComponent"),
            .target(name: "XCTEventDetailComponent"),
            .target(name: "XCTEventFeedbackComponent"),
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
        
        .target(name: "XCTEventFeedbackComponent", dependencies: [
            .target(name: "EventFeedbackComponent"),
            .target(name: "XCTComponentBase")
        ]),
        
        .testTarget(name: "EventFeedbackComponentTests", dependencies: [
            .target(name: "EventFeedbackComponent"),
            .target(name: "XCTComponentBase"),
            .target(name: "XCTEventFeedbackComponent"),
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
        
        .target(name: "XCTDealerComponent", dependencies: [
            .target(name: "DealerComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "DealerComponentTests", dependencies: [
            .target(name: "DealerComponent"),
            .target(name: "XCTComponentBase"),
            .target(name: "XCTDealerComponent"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Knowledge Journey
        
        .target(name: "KnowledgeJourney", dependencies: [
            .target(name: "KnowledgeGroupsComponent"),
            .target(name: "KnowledgeGroupComponent"),
            .target(name: "KnowledgeDetailComponent"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "KnowledgeJourneyTests", dependencies: [
            .target(name: "KnowledgeJourney"),
            .target(name: "XCTComponentBase"),
            .target(name: "XCTKnowledgeGroupComponent"),
            .target(name: "XCTKnowledgeDetailComponent"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Knowledge Groups
        
        .target(name: "KnowledgeGroupsComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .testTarget(name: "KnowledgeGroupsComponentTests", dependencies: [
            .target(name: "KnowledgeGroupsComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Knowledge Group
        
        .target(name: "KnowledgeGroupComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .target(name: "XCTKnowledgeGroupComponent", dependencies: [
            .target(name: "KnowledgeGroupComponent"),
            .target(name: "XCTComponentBase"),
            .product(name: "TestUtilities", package: "TestUtilities")
        ]),
        
        .testTarget(name: "KnowledgeGroupComponentTests", dependencies: [
            .target(name: "KnowledgeGroupComponent"),
            .target(name: "XCTComponentBase"),
            .target(name: "XCTKnowledgeGroupComponent"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ]),
        
        // MARK: Knowledge Detail
        
        .target(name: "KnowledgeDetailComponent", dependencies: [
            .target(name: "ComponentBase"),
            .product(name: "EurofurenceModel", package: "EurofurenceModel")
        ]),
        
        .target(name: "XCTKnowledgeDetailComponent", dependencies: [
            .target(name: "KnowledgeDetailComponent")
        ]),
        
        .testTarget(name: "KnowledgeDetailComponentTests", dependencies: [
            .target(name: "KnowledgeDetailComponent"),
            .target(name: "XCTComponentBase"),
            .target(name: "XCTKnowledgeDetailComponent"),
            .product(name: "XCTEurofurenceModel", package: "EurofurenceModel")
        ])
        
    ]
)
