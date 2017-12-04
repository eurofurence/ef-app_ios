//
//  WhenTheAppLaunches.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingRootWireframe: RootModuleDelegate {
    
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
    
    func testAndTheUserHasNotFinishedTheTutorialTheDelegateIsToldTheUserNeedsToWitnessTutorial() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(rootWireframe)
        
        XCTAssertTrue(rootWireframe.wasToldUserNeedsToWitnessTutorial)
    }
    
    func testAndTheUserHasNotFinishedTheTutorialTheDelegateIsNotToldToPreloadStore() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(rootWireframe)
        
        XCTAssertFalse(rootWireframe.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsToldToPreloadStore() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(rootWireframe)

        XCTAssertTrue(rootWireframe.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsNotToldTheUserNeedsToWitnessTutorial() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        let factory = PhoneRootModuleFactory(firstTimeLaunchStateProviding: notCompletedTutorial)
        _ = factory.makeRootModule(rootWireframe)
        
        XCTAssertFalse(rootWireframe.wasToldUserNeedsToWitnessTutorial)
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
