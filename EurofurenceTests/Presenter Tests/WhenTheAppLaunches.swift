//
//  WhenTheAppLaunches.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class CapturingPresentationModule: PresentationModule {

    private(set) var attachedWireframe: PresentationWireframe?
    func attach(to wireframe: PresentationWireframe) {
        attachedWireframe = wireframe
    }
    
    func didAttach(to wireframe: PresentationWireframe) -> Bool {
        return wireframe === attachedWireframe
    }
    
}

class CapturingPresentationWireframe: PresentationWireframe {
    
    private(set) var capturedRootScene: AnyObject?
    func show(_ scene: AnyObject) {
        capturedRootScene = scene
    }
    
}

struct RootModule {
    
    init(rootWireframe: RootWireframe,
         firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding) {
        if firstTimeLaunchStateProviding.userHasCompletedTutorial {
            rootWireframe.showPreloadScreen()
        }
        else {
            rootWireframe.showTutorialScreen()
        }
    }
    
}

protocol RootWireframe {
    
    func showTutorialScreen()
    func showPreloadScreen()
    
}

class CapturingRootWireframe: RootWireframe {
    
    private(set) var didShowTutorial = false
    func showTutorialScreen() {
        didShowTutorial = true
    }
    
    private(set) var didShowPreload = false
    func showPreloadScreen() {
        didShowPreload = true
    }
    
}

class WhenTheAppLaunches: XCTestCase {
    
    // MARK: New
    
    func testAndTheUserHasNotFinishedTheTutorialTheRootWireframeIsToldToShowTheTutorialScreen() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = RootModule(rootWireframe: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)
        
        XCTAssertTrue(rootWireframe.didShowTutorial)
    }
    
    func testAndTheUserHasNotFinishedTheTutorialTheRootWireframeIsNotToldToShowThePreloadScreen() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        _ = RootModule(rootWireframe: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)
        
        XCTAssertFalse(rootWireframe.didShowPreload)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheRootWireframeIsToldToShowThePreloadScreen() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = RootModule(rootWireframe: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)

        XCTAssertTrue(rootWireframe.didShowPreload)
    }
    
    func testAndTheUserHasFinishedTheTutorialTheRootWireframeIsNotToldToShowTheTutorialScreen() {
        let rootWireframe = CapturingRootWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        _ = RootModule(rootWireframe: rootWireframe,
                       firstTimeLaunchStateProviding: notCompletedTutorial)
        
        XCTAssertFalse(rootWireframe.didShowTutorial)
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
