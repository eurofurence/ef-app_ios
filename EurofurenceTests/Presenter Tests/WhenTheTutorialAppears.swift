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

    private func showTutorial(_ networkReachability: NetworkReachability = StubNetworkReachability(),
                              _ splashRouter: CapturingSplashScreenRouter = CapturingSplashScreenRouter()) -> TutorialTestContext {
        let tutorialRouter = CapturingTutorialRouter()
        let alertRouter = CapturingAlertRouter()
        let routers = StubRouters(tutorialRouter: tutorialRouter,
                                  splashScreenRouter: splashRouter,
                                  alertRouter: alertRouter)
        let context = TestingApplicationContextBuilder()
            .forShowingTutorial()
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
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorial.wasToldToShowTutorialPage)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheTitleForBeginningInitialLoad() {
        let setup = showTutorial()

        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadTitle),
                       setup.page.capturedPageTitle)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheDescriptionForBeginningInitialLoad() {
        let setup = showTutorial()

        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadDescription),
                       setup.page.capturedPageDescription)
    }

    func testItShouldShowTheInformationImageForBeginningInitialLoad() {
        let setup = showTutorial()

        XCTAssertEqual(setup.assets.initialLoadInformationAsset,
                       setup.page.capturedPageImage)
    }
    
    func testItShouldShowThePrimaryActionButtonForTheInitiateDownloadTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.page.didShowPrimaryActionButton)
    }
    
    func testItShouldTellTheTutorialPageToShowTheBeginDownloadTextOnThePrimaryActionButton() {
        let setup = showTutorial()
        
        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadBeginDownload),
                       setup.page.capturedPrimaryActionDescription)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableTellsSplashRouterToShowTheSplashScreen() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = true
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlert() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableShouldNotTellSplashScreenRouterToShowTheSplashScreen() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableDoesNotTellAlertRouterToShowAlert() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = true
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsTitle() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings.presentationString(for: .cellularDownloadAlertTitle),
                       setup.alertRouter.presentedAlertTitle)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsMessage() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings.presentationString(for: .cellularDownloadAlertMessage),
                       setup.alertRouter.presentedAlertMessage)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithContinueDownloadOverCellularAction() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.first

        XCTAssertEqual(setup.strings.presentationString(for: .cellularDownloadAlertContinueOverCellularTitle),
                       action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithCancelAction() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.last

        XCTAssertEqual(setup.strings.presentationString(for: .cancel),
                       action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableThenInvokingFirstActionShouldTellTheSplashRouterToShowTheSplashScreen() {
        var networkReachability = StubNetworkReachability()
        networkReachability.wifiReachable = false
        let splashRouter = CapturingSplashScreenRouter()
        let setup = showTutorial(networkReachability, splashRouter)
        setup.page.simulateTappingPrimaryActionButton()
        setup.alertRouter.presentedActions.first?.invoke()

        XCTAssertTrue(setup.splashRouter.wasToldToShowSplashScreen)
    }

}
