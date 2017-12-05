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
    
    func testAndTheUserHasNotFinishedTheTutorialTheDelegateIsToldTheUserNeedsToWitnessTutorial() {
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(delegate)
        
        XCTAssertTrue(delegate.wasToldUserNeedsToWitnessTutorial)
    }
    
    func testAndTheUserHasNotFinishedTheTutorialTheDelegateIsNotToldToPreloadStore() {
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(delegate)
        
        XCTAssertFalse(delegate.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsToldToPreloadStore() {
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(delegate)

        XCTAssertTrue(delegate.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsNotToldTheUserNeedsToWitnessTutorial() {
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(delegate)
        
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
