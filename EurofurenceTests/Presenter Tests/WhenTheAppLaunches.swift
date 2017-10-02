//
//  WhenTheAppLaunches.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingPresentationWireframe: PresentationWireframe {
    
    private(set) var capturedRootScene: AnyObject?
    func show(_ scene: AnyObject) {
        capturedRootScene = scene
    }
    
}

struct RootModule {
    
    init(delegate: RootModuleDelegate,
         firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding) {
        if firstTimeLaunchStateProviding.userHasCompletedTutorial {
            delegate.storeShouldBePreloaded()
        }
        else {
            delegate.userNeedsToWitnessTutorial()
        }
    }
    
}

protocol RootModuleDelegate {
    
    func userNeedsToWitnessTutorial()
    func storeShouldBePreloaded()
    
}

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
        _ = RootModule(delegate: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)
        
        XCTAssertTrue(rootWireframe.wasToldUserNeedsToWitnessTutorial)
    }
    
    func testAndTheUserHasNotFinishedTheTutorialTheDelegateIsNotToldToPreloadStore() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = RootModule(delegate: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)
        
        XCTAssertFalse(rootWireframe.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsToldToPreloadStore() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = RootModule(delegate: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)

        XCTAssertTrue(rootWireframe.wasToldToPreloadStore)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheDelegateIsNotToldTheUserNeedsToWitnessTutorial() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = RootModule(delegate: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)
        
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
