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
                                   routers: routers)

        XCTAssertTrue(tutorialRouter.tutorialScene.wasToldToShowTutorialPage)
    }
    
}
