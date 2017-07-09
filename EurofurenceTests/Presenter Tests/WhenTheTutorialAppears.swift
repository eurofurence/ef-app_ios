//
//  WhenTheTutorialAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheTutorialAppears: XCTestCase {
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialItems: [],
                                   routers: routers)

        XCTAssertTrue(tutorialRouter.tutorialScene.wasToldToShowTutorialPage)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheTitleFromTheFirstTutorialItem() {
        let expectedTitle = "Tutorial title"
        let firstTutorialItem = TutorialPageInfo(image: nil, title: expectedTitle, description: nil)
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialItems: [firstTutorialItem],
                                   routers: routers)

        XCTAssertEqual(expectedTitle, tutorialRouter.tutorialScene.tutorialPage.capturedPageTitle)
    }
    
}
