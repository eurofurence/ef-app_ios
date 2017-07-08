//
//  BootstrappingPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class BootstrappingPresenterTests: XCTestCase {
    
    func testWhenTheAppHasNotRunBeforeTheTutorialRouterIsToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialRouter: tutorialRouter,
                                   splashScreenRouter: CapturingSplashScreenRouter())

        XCTAssertTrue(tutorialRouter.wasToldToShowTutorial)
    }

    func testWhenTheAppHasRunBeforeTheSplashScreenRouterIsToldToShowTheSplashScreen() {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialRouter: CapturingTutorialRouter(),
                                   splashScreenRouter: splashScreenRouter)

        XCTAssertTrue(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testWhenTheAppHasNotRunBeforeTheTheSplashScreenRouterShouldNotBeToldToShowTheSplashScree () {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialRouter: CapturingTutorialRouter(),
                                   splashScreenRouter: splashScreenRouter)

        XCTAssertFalse(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testWhenTheAppHasRunBeforeTheTutorialRouterShouldNotBeToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialRouter: tutorialRouter,
                                   splashScreenRouter: CapturingSplashScreenRouter())

        XCTAssertFalse(tutorialRouter.wasToldToShowTutorial)
    }
    
}
