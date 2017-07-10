//
//  WhenTheTutorialAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenTheTutorialAppears: XCTestCase {

    struct TutorialTestContext {
        var tutorial: CapturingTutorialScene
        var page: CapturingTutorialPageScene
        var strings: PresentationStrings
        var assets: PresentationAssets
        var splashRouter: CapturingSplashScreenRouter
        var alertRouter: CapturingAlertRouter
    }

    private func showTutorial(_ items: [TutorialPageInfo] = [],
                              _ networkReachability: NetworkReachability = StubNetworkReachability(),
                              _ splashRouter: CapturingSplashScreenRouter = CapturingSplashScreenRouter()) -> TutorialTestContext {
        let tutorialRouter = CapturingTutorialRouter()
        let alertRouter = CapturingAlertRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter,
                                  splashScreenRouter: splashRouter,
                                  alertRouter: alertRouter)
        let context = TestingApplicationContextBuilder()
            .forShowingTutorial()
            .withTutorialItems(items)
            .withNetworkReachability(networkReachability)
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)

        return TutorialTestContext(tutorial: tutorialRouter.tutorialScene,
                                   page: tutorialRouter.tutorialScene.tutorialPage,
                                   strings: context.presentationStrings,
                                   assets: context.presentationAssets,
                                   splashRouter: splashRouter,
                                   alertRouter: alertRouter)
    }
    
    private func makeTutorialItemWithPrimaryCapturingAction() -> (item: TutorialPageInfo, action: CapturingAction) {
        let capturingAction = CapturingAction()
        let action = TutorialPageAction(actionDescription: "", action: capturingAction)
        return (item: TutorialPageInfo(image: nil, title: nil, description: nil, primaryAction: action), action: capturingAction)
    }
    
    private func makeTutorialItemWithSecondaryCapturingAction() -> (item: TutorialPageInfo, action: CapturingAction) {
        let capturingAction = CapturingAction()
        let action = TutorialPageAction(actionDescription: "", action: capturingAction)
        return (item: TutorialPageInfo(image: nil, title: nil, description: nil, secondaryAction: action), action: capturingAction)
    }
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorial.wasToldToShowTutorialPage)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheTitleForBeginningInitialLoad() {
        let setup = showTutorial([])

        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadTitle),
                       setup.page.capturedPageTitle)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheDescriptionForBeginningInitialLoad() {
        let setup = showTutorial([])

        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadDescription),
                       setup.page.capturedPageDescription)
    }

    func testItShouldShowTheInformationImageForBeginningInitialLoad() {
        let setup = showTutorial([])

        XCTAssertEqual(setup.assets.initialLoadInformationAsset,
                       setup.page.capturedPageImage)
    }
    
    func testItShouldShowThePrimaryActionButtonForTheInitiateDownloadTutorialPage() {
        let setup = showTutorial([])
        XCTAssertTrue(setup.page.didShowPrimaryActionButton)
    }
    
    func testItShouldTellTheTutorialPageToShowTheBeginDownloadTextOnThePrimaryActionButton() {
        let setup = showTutorial([])
        
        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadBeginDownload),
                       setup.page.capturedPrimaryActionDescription)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableTellsSplashRouterToShowTheSplashScreen() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = true
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial([], networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlert() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial([], networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableShouldNotTellSplashScreenRouterToShowTheSplashScreen() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial([], networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableDoesNotTellAlertRouterToShowAlert() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = true
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial([], networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.alertRouter.didShowAlert)
    }

    // TODO: Rework
    
    func testItShouldTellTheFirstTutorialPageToShowTheSecondaryActionButtonWhenSecondaryActionAvailable() {
        let firstTutorialItem = makeTutorialItemWithSecondaryCapturingAction().item
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertTrue(setup.page.didShowSecondaryActionButton)
    }
    
    func testItShouldNotTellTheFirstTutorialPageToShowTheSeondaryActionButtonWhenSecondaryActionIsNotAvailable() {
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, secondaryAction: nil)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertFalse(setup.page.didShowSecondaryActionButton)
    }

    func testItShouldTellTheTutorialPageToShowTheSecondaryActionTextWhenSecondaryActionAvailable() {
        let expectedActionDescription = "Do voodoo"
        let action = TutorialPageAction(actionDescription: expectedActionDescription, action: CapturingAction())
        let firstTutorialItem = TutorialPageInfo(image: nil, title: nil, description: nil, secondaryAction: action)
        let setup = showTutorial([firstTutorialItem])
        
        XCTAssertEqual(expectedActionDescription, setup.page.capturedSecondaryActionDescription)
    }
    
    func testTappingThePrimaryActionButtonShouldInvokeThePrimaryActionForTheFirstPage() {
        let actionSetup = makeTutorialItemWithPrimaryCapturingAction()
        let setup = showTutorial([actionSetup.item])
        setup.page.simulateTappingPrimaryActionButton()
        
        XCTAssertTrue(actionSetup.action.didRun)
    }
    
    func testTappingTheSecondaryActionButtonShouldInvokeTheSecondaryActionForTheFirstPage() {
        let actionSetup = makeTutorialItemWithSecondaryCapturingAction()
        let setup = showTutorial([actionSetup.item])
        setup.page.simulateTappingSecondaryActionButton()
        
        XCTAssertTrue(actionSetup.action.didRun)
    }
    
    func testWhenThePrimaryActionCompletesWithOnlyOnePageInTheTutorialTheSplashRouterIsToldToShowTheSplashScreen() {
        let setup = makeTutorialItemWithPrimaryCapturingAction()
        let tutorialRouter = CapturingTutorialRouter()
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter, splashScreenRouter: splashRouter)
        let context = TestingApplicationContextBuilder()
            .forShowingTutorial()
            .withTutorialItems([setup.item])
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)
        tutorialRouter.tutorialScene.tutorialPage.simulateTappingPrimaryActionButton()
        setup.action.notifyHandlerActionDidFinish()
        
        XCTAssertTrue(splashRouter.wasToldToShowSplashScreen)
    }
    
    func testWhenThePrimaryActionCompletesWithOnlyOnePageInTheTutorialTheTutorialStateProviderIsToldToMarkTheTutorialAsComplete() {
        let setup = makeTutorialItemWithPrimaryCapturingAction()
        let tutorialRouter = CapturingTutorialRouter()
        let finishedTutorialProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let context = TestingApplicationContextBuilder()
            .withUserCompletedTutorialStateProviding(finishedTutorialProvider)
            .withTutorialItems([setup.item])
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)
        tutorialRouter.tutorialScene.tutorialPage.simulateTappingPrimaryActionButton()
        setup.action.notifyHandlerActionDidFinish()
        
        XCTAssertTrue(finishedTutorialProvider.didMarkTutorialAsComplete)
    }
    
    func testWhenThePrimaryActionIsInstigatedButHasNotFinishedWithOnlyOnePageInTheTutorialTheTutorialStateProviderIsNotToldToMarkTheTutorialAsComplete() {
        let setup = makeTutorialItemWithPrimaryCapturingAction()
        let tutorialRouter = CapturingTutorialRouter()
        let finishedTutorialProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let context = TestingApplicationContextBuilder()
            .withUserCompletedTutorialStateProviding(finishedTutorialProvider)
            .withTutorialItems([setup.item])
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)
        tutorialRouter.tutorialScene.tutorialPage.simulateTappingPrimaryActionButton()
        
        XCTAssertFalse(finishedTutorialProvider.didMarkTutorialAsComplete)
    }
    
    func testWhenTheSecondaryActionCompletesWithOnlyOnePageInTheTutorialTheSplashRouterIsToldToShowTheSplashScreen() {
        let setup = makeTutorialItemWithSecondaryCapturingAction()
        let tutorialRouter = CapturingTutorialRouter()
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter, splashScreenRouter: splashRouter)
        let context = TestingApplicationContextBuilder()
            .forShowingTutorial()
            .withTutorialItems([setup.item])
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)
        tutorialRouter.tutorialScene.tutorialPage.simulateTappingSecondaryActionButton()
        setup.action.notifyHandlerActionDidFinish()
        
        XCTAssertTrue(splashRouter.wasToldToShowSplashScreen)
    }
    
    func testWhenTheSecondaryActionCompletesWithOnlyOnePageInTheTutorialTheTutorialStateProviderIsToldToMarkTheTutorialAsComplete() {
        let setup = makeTutorialItemWithSecondaryCapturingAction()
        let tutorialRouter = CapturingTutorialRouter()
        let finishedTutorialProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let context = TestingApplicationContextBuilder()
            .withUserCompletedTutorialStateProviding(finishedTutorialProvider)
            .withTutorialItems([setup.item])
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)
        tutorialRouter.tutorialScene.tutorialPage.simulateTappingSecondaryActionButton()
        setup.action.notifyHandlerActionDidFinish()
        
        XCTAssertTrue(finishedTutorialProvider.didMarkTutorialAsComplete)
    }
    
    func testWhenTheSecondaryActionIsInstigatedButHasNotFinishedWithOnlyOnePageInTheTutorialTheSplashRouterIsNotToldToShowTheSplashScreen() {
        let setup = makeTutorialItemWithSecondaryCapturingAction()
        let tutorialRouter = CapturingTutorialRouter()
        let splashRouter = CapturingSplashScreenRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter, splashScreenRouter: splashRouter)
        let context = TestingApplicationContextBuilder()
            .forShowingTutorial()
            .withTutorialItems([setup.item])
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)
        tutorialRouter.tutorialScene.tutorialPage.simulateTappingSecondaryActionButton()
        
        XCTAssertFalse(splashRouter.wasToldToShowSplashScreen)
    }
    
    func testWhenTheSecondaryActionIsInstigatedButHasNotFinishedWithOnlyOnePageInTheTutorialTheTutorialStateProviderIsNotToldToMarkTheTutorialAsComplete() {
        let setup = makeTutorialItemWithSecondaryCapturingAction()
        let tutorialRouter = CapturingTutorialRouter()
        let finishedTutorialProvider = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let routers = StubRouters(tutorialRouter: tutorialRouter)
        let context = TestingApplicationContextBuilder()
            .withUserCompletedTutorialStateProviding(finishedTutorialProvider)
            .withTutorialItems([setup.item])
            .build()
        BootstrappingModule.bootstrap(context: context, routers: routers)
        tutorialRouter.tutorialScene.tutorialPage.simulateTappingSecondaryActionButton()
        
        XCTAssertFalse(finishedTutorialProvider.didMarkTutorialAsComplete)
    }

}
