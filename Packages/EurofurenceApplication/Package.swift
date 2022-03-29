// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "EurofurenceApplication",
    defaultLocalization: "en",
    platforms: [.iOS(.v13)],
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
        .package(path: "../TestUtilities"),
        
        .package(url: "https://github.com/ShezHsky/Router.git", .upToNextMajor(from: .init(0, 0, 2))),
        .package(url: "https://github.com/ShezHsky/ObservedObject.git", .upToNextMajor(from: .init(0, 0, 1)))
    ],
    targets: [
        .target(
            name: "EurofurenceApplication",
            dependencies: [
                .product(name: "EurofurenceModel", package: "EurofurenceModel"),
                .product(name: "EurofurenceApplicationSession", package: "EurofurenceApplicationSession"),
                .product(name: "Router", package: "Router"),
                .product(name: "ObservedObject", package: "ObservedObject"),
                
                .product(name: "ScheduleComponent", package: "EurofurenceComponents"),
                .product(name: "EventsJourney", package: "EurofurenceComponents"),
                .product(name: "EventDetailComponent", package: "EurofurenceComponents"),
                .product(name: "EventFeedbackComponent", package: "EurofurenceComponents"),
                .product(name: "DealersJourney", package: "EurofurenceComponents"),
                .product(name: "DealersComponent", package: "EurofurenceComponents"),
                .product(name: "DealerComponent", package: "EurofurenceComponents"),
                .product(name: "PreloadComponent", package: "EurofurenceComponents"),
                .product(name: "TutorialComponent", package: "EurofurenceComponents"),
                .product(name: "KnowledgeJourney", package: "EurofurenceComponents"),
                .product(name: "KnowledgeGroupsComponent", package: "EurofurenceComponents"),
                .product(name: "KnowledgeGroupComponent", package: "EurofurenceComponents"),
                .product(name: "KnowledgeDetailComponent", package: "EurofurenceComponents"),
                .product(name: "ContentController", package: "EurofurenceComponents"),
                .product(name: "URLContent", package: "EurofurenceComponents")
            ]
        ),
        
        .testTarget(
            name: "EurofurenceApplicationTests",
            dependencies: [
                .target(name: "EurofurenceApplication"),
                .product(name: "XCTRouter", package: "Router"),
                .product(name: "XCTEurofurenceModel", package: "EurofurenceModel"),
                .product(name: "XCTComponentBase", package: "EurofurenceComponents"),
                .product(name: "XCTDealerComponent", package: "EurofurenceComponents"),
                .product(name: "XCTEventFeedbackComponent", package: "EurofurenceComponents"),
                .product(name: "XCTEventDetailComponent", package: "EurofurenceComponents"),
                .product(name: "XCTKnowledgeDetailComponent", package: "EurofurenceComponents"),
                .product(name: "XCTKnowledgeGroupComponent", package: "EurofurenceComponents"),
                .product(name: "XCTScheduleComponent", package: "EurofurenceComponents"),
                .product(name: "TestUtilities", package: "TestUtilities")
            ]
        )
    ]
)
