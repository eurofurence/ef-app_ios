//
//  WhenTheAppLaunches.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 08/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class StubModuleAttacher: ModuleAttacher {

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
    func setRoot(_ scene: AnyObject) {
        capturedRootScene = scene
    }
    
}

struct RootModule: ModuleAttacher {
    
    private let tutorialModuleFactory: ModuleAttacher
    private let preloadModuleFactory: ModuleAttacher
    private let firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding
    
    init(tutorialModuleFactory: ModuleAttacher,
         preloadModuleFactory: ModuleAttacher,
         firstTimeLaunchStateProviding: UserCompletedTutorialStateProviding) {
        self.tutorialModuleFactory = tutorialModuleFactory
        self.preloadModuleFactory = preloadModuleFactory
        self.firstTimeLaunchStateProviding = firstTimeLaunchStateProviding
    }
    
    func attach(to wireframe: PresentationWireframe) {
        if firstTimeLaunchStateProviding.userHasCompletedTutorial {
            preloadModuleFactory.attach(to: wireframe)
        }
        else {
            tutorialModuleFactory.attach(to: wireframe)
        }
    }
    
}

class WhenTheAppLaunches: XCTestCase {
    
    // MARK: New
    
    func testAndTheUserHasNotFinishedTheTutorialTheTutorialModuleShouldAttachToTheWireframe() {
        let tutorialModule = StubModuleAttacher()
        let wireframe = CapturingPresentationWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let module = RootModule(tutorialModuleFactory: tutorialModule,
                                preloadModuleFactory: StubModuleAttacher(),
                                firstTimeLaunchStateProviding: notCompletedTutorial)
        module.attach(to: wireframe)
        
        XCTAssertTrue(tutorialModule.didAttach(to: wireframe))
    }
    
    func testAndTheUserHasFinishedTheTutorialThePreloadModuleShouldAttachToTheRootWireframe() {
        let tutorialModule = StubModuleAttacher()
        let preloadmodule = StubModuleAttacher()
        let wireframe = CapturingPresentationWireframe()
        let notCompletedTutorial = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: true)
        let module = RootModule(tutorialModuleFactory: tutorialModule,
                                preloadModuleFactory: preloadmodule,
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
