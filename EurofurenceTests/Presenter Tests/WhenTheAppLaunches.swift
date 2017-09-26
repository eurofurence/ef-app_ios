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

struct RootModule: PresentationModule {
    
    private let tutorialModule: PresentationModule
    private let preloadModule: PresentationModule
    private let firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding
    
    init(tutorialModule: PresentationModule,
         preloadModule: PresentationModule,
         firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding) {
        self.tutorialModule = tutorialModule
        self.preloadModule = preloadModule
        self.firstTimeLaunchStateProviding = firstTimeLaunchStateProviding
    }
    
    func attach(to wireframe: PresentationWireframe) {
        if firstTimeLaunchStateProviding.userHasCompletedTutorial {
            preloadModule.attach(to: wireframe)
        }
        else {
            tutorialModule.attach(to: wireframe)
        }
    }
    
}

class WhenTheAppLaunches: XCTestCase {
    
    // MARK: New
    
    func testAndTheUserHasNotFinishedTheTutorialTheTutorialModuleShouldAttachToTheWireframe() {
        let tutorialModule = CapturingPresentationModule()
        let wireframe = CapturingPresentationWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let module = RootModule(tutorialModule: tutorialModule,
                                preloadModule: CapturingPresentationModule(),
                                firstTimeLaunchStateProviding: notCompletedTutorial)
        module.attach(to: wireframe)
        
        XCTAssertTrue(tutorialModule.didAttach(to: wireframe))
    }
    
    func testAndTheUserHasFinishedTheTutorialThePreloadModuleShouldAttachToTheRootWireframe() {
        let tutorialModule = CapturingPresentationModule()
        let preloadmodule = CapturingPresentationModule()
        let wireframe = CapturingPresentationWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        let module = RootModule(tutorialModule: tutorialModule,
                                preloadModule: preloadmodule,
                                firstTimeLaunchStateProviding: notCompletedTutorial)
        module.attach(to: wireframe)

        XCTAssertTrue(preloadmodule.didAttach(to: wireframe))
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
