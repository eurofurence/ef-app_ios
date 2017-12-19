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
    
    private(set) var wasToldToShowPrincipleModule = false
    func rootModuleDidDetermineRootModuleShouldBePresented() {
        wasToldToShowPrincipleModule = true
    }
    
}

class WhenTheAppLaunches: XCTestCase {
    
    // MARK: New
    
    var app: CapturingEurofurenceApplication!
    var delegate: CapturingRootModuleDelegate!
    
    override func setUp() {
        super.setUp()
        
        app = CapturingEurofurenceApplication()
        delegate = CapturingRootModuleDelegate()
        _ = RootModuleBuilder().with(app).build().makeRootModule(delegate)
    }
    
    private func simulateAbsentStore() {
        app.capturedStoreStateResolutionHandler?(.absent)
    }
    
    private func simulateStaleStore() {
        app.capturedStoreStateResolutionHandler?(.stale)
    }
    
    private func simulateAvailableStore() {
        app.capturedStoreStateResolutionHandler?(.available)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsToldToPreloadStore() {
        simulateStaleStore()
        XCTAssertTrue(delegate.wasToldToPreloadStore)
    }
    
    func testAndTheStoreIsAbsentTheDelegateIsNotToldToPreloadStore() {
        simulateAbsentStore()
        XCTAssertFalse(delegate.wasToldToPreloadStore)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToPreloadStore() {
        simulateAvailableStore()
        XCTAssertFalse(delegate.wasToldToPreloadStore)
    }
    
    func testAndTheStoreIsAbsentTheDelegateIsToldToShowTutorial() {
        simulateAbsentStore()
        XCTAssertTrue(delegate.wasToldUserNeedsToWitnessTutorial)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowTutorial() {
        simulateStaleStore()
        XCTAssertFalse(delegate.wasToldUserNeedsToWitnessTutorial)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowTutorial() {
        simulateAvailableStore()
        XCTAssertFalse(delegate.wasToldUserNeedsToWitnessTutorial)
    }
    
    func testAndTheStoreIsAbsentTheDelegateIsNotToldToShowPrincipleModule() {
        simulateAbsentStore()
        XCTAssertFalse(delegate.wasToldToShowPrincipleModule)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowPrincipleModule() {
        simulateStaleStore()
        XCTAssertFalse(delegate.wasToldToShowPrincipleModule)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowPrincipleModule() {
        simulateAvailableStore()
        XCTAssertTrue(delegate.wasToldToShowPrincipleModule)
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
