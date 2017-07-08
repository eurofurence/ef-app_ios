//
//  BootstrappingPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import XCTest

protocol UserCompletedTutorialStateProviding {

    var userHasCompletedTutorial: Bool { get }

}

protocol TutorialRouter {

    func showTutorial()

}

protocol SplashScreenRouter {

    func showSplashScreen()

}

class CapturingTutorialRouter: TutorialRouter {

    private(set) var wasToldToShowTutorial = false
    func showTutorial() {
        wasToldToShowTutorial = true
    }

}

class CapturingSplashScreenRouter: SplashScreenRouter {

    private(set) var wasToldToShowSplashScreen = false
    func showSplashScreen() {
        wasToldToShowSplashScreen = true
    }

}

struct StubFirstTimeLaunchStateProvider: UserCompletedTutorialStateProviding {

    var userHasCompletedTutorial: Bool

}

class BootstrappingPresenter {

    init(firstTimeLaunchProviding: UserCompletedTutorialStateProviding,
         tutorialRouter: TutorialRouter,
         splashScreenRouter: SplashScreenRouter) {
        if firstTimeLaunchProviding.userHasCompletedTutorial {
            splashScreenRouter.showSplashScreen()
        }
        else {
            tutorialRouter.showTutorial()
        }
    }

}

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
