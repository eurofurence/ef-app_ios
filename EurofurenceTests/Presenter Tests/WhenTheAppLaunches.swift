//
//  WhenTheAppLaunches.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingRootModuleDelegate: RootModuleDelegate {
    
    private(set) var wasToldUserNeedsToWitnessTutorial = false
    func userNeedsToWitnessTutorial() {
        wasToldUserNeedsToWitnessTutorial = true
    }
    
    private(set) var wasToldToPreloadStore = false
    func storeShouldBePreloaded() {
        wasToldToPreloadStore = true
    }
    
}

class WhenTheAppLaunches: XCTestCase {
    
    // MARK: New
    
    var delegate: CapturingRootModuleDelegate!
    
    override func setUp() {
        super.setUp()
        delegate = CapturingRootModuleDelegate()
    }
    
    private func makeRootModule(userHasCompletedTutorial tutorialState: Bool) {
        _ = RootModuleBuilder()
            .with(StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: tutorialState))
            .build()
            .makeRootModule(delegate)
    }
    
    func testAndTheUserHasNotFinishedTheTutorialTheDelegateIsToldTheUserNeedsToWitnessTutorial() {
        makeRootModule(userHasCompletedTutorial: false)
        XCTAssertTrue(delegate.wasToldUserNeedsToWitnessTutorial)
    }
    
    func testAndTheUserHasNotFinishedTheTutorialTheDelegateIsNotToldToPreloadStore() {
        makeRootModule(userHasCompletedTutorial: false)
        XCTAssertFalse(delegate.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsToldToPreloadStore() {
        makeRootModule(userHasCompletedTutorial: true)
        XCTAssertTrue(delegate.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsNotToldTheUserNeedsToWitnessTutorial() {
        makeRootModule(userHasCompletedTutorial: true)
        XCTAssertFalse(delegate.wasToldUserNeedsToWitnessTutorial)
    }
    
    // MARK: Old
    
    func testAndTheUserHasNotFinishedTheTutorialTheTutorialRouterIsToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        PresentationTestBuilder().withRouters(routers).forShowingTutorial().build().bootstrap()

        XCTAssertTrue(tutorialRouter.wasToldToShowTutorial)
    }

    func testAndTheUserHasPreviouslyFinishedTheTutorialTheSplashRouterIsToldToShowTheSplashScreen() {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashScreenRouter)
        PresentationTestBuilder().withRouters(routers).build().bootstrap()

        XCTAssertTrue(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testAndTheUserHasNotFinishedTheTutorialTheSplashScreenRouterShouldNotBeToldToShowTheSplashScreen() {
        let splashScreenRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(splashScreenRouter: splashScreenRouter)
        PresentationTestBuilder().withRouters(routers).forShowingTutorial().build().bootstrap()

        XCTAssertFalse(splashScreenRouter.wasToldToShowSplashScreen)
    }

    func testAndTheUserHasPreviouslyFinishedTheTutorialTheTutorialRouterShouldNotBeToldToShowTheTutorial() {
        let tutorialRouter = CapturingTutorialRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        PresentationTestBuilder().withRouters(routers).build().bootstrap()

        XCTAssertFalse(tutorialRouter.wasToldToShowTutorial)
    }
    
}
