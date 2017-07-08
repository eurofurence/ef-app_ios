//
//  BootstrappingPresenterTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import XCTest

protocol FirstTimeLaunchStateProviding {

    var userHasOpenedAppBefore: Bool { get }

}

protocol TutorialRouter {

    func showTutorial()

}

class CapturingTutorialRouter: TutorialRouter {

    private(set) var wasToldToShowTutorial = false
    func showTutorial() {
        wasToldToShowTutorial = true
    }

}

struct StubFirstTimeLaunchStateProvider: FirstTimeLaunchStateProviding {

    var userHasOpenedAppBefore: Bool

}

class BootstrappingPresenter {

    init(firstTimeLaunchProviding: FirstTimeLaunchStateProviding, tutorialRouter: TutorialRouter) {
        tutorialRouter.showTutorial()
    }

}

class BootstrappingPresenterTests: XCTestCase {
    
    func testWhenTheAppHasNotRunBeforeTheTutorialRouterIsToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let initialAppStateProvider = StubFirstTimeLaunchStateProvider(userHasOpenedAppBefore: false)
        _ = BootstrappingPresenter(firstTimeLaunchProviding: initialAppStateProvider,
                                   tutorialRouter: tutorialRouter)

        XCTAssertTrue(tutorialRouter.wasToldToShowTutorial)
    }
    
}
