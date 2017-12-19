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
    
    private(set) var toldTutorialShouldBePresented = false
    func rootModuleDidDetermineTutorialShouldBePresented() {
        toldTutorialShouldBePresented = true
    }
    
    private(set) var toldStoreShouldRefresh = false
    func rootModuleDidDetermineStoreShouldRefresh() {
        toldStoreShouldRefresh = true
    }
    
    private(set) var toldPrincipleModuleShouldBePresented = false
    func rootModuleDidDetermineRootModuleShouldBePresented() {
        toldPrincipleModuleShouldBePresented = true
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
        XCTAssertTrue(delegate.toldStoreShouldRefresh)
    }
    
    func testAndTheStoreIsAbsentTheDelegateIsNotToldToPreloadStore() {
        simulateAbsentStore()
        XCTAssertFalse(delegate.toldStoreShouldRefresh)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToPreloadStore() {
        simulateAvailableStore()
        XCTAssertFalse(delegate.toldStoreShouldRefresh)
    }
    
    func testAndTheStoreIsAbsentTheDelegateIsToldToShowTutorial() {
        simulateAbsentStore()
        XCTAssertTrue(delegate.toldTutorialShouldBePresented)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowTutorial() {
        simulateStaleStore()
        XCTAssertFalse(delegate.toldTutorialShouldBePresented)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowTutorial() {
        simulateAvailableStore()
        XCTAssertFalse(delegate.toldTutorialShouldBePresented)
    }
    
    func testAndTheStoreIsAbsentTheDelegateIsNotToldToShowPrincipleModule() {
        simulateAbsentStore()
        XCTAssertFalse(delegate.toldPrincipleModuleShouldBePresented)
    }
    
    func testAndTheStoreIsStaleTheDelegateIsNotToldToShowPrincipleModule() {
        simulateStaleStore()
        XCTAssertFalse(delegate.toldPrincipleModuleShouldBePresented)
    }
    
    func testAndTheStoreIsAvailableTheDelegateIsNotToldToShowPrincipleModule() {
        simulateAvailableStore()
        XCTAssertTrue(delegate.toldPrincipleModuleShouldBePresented)
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
