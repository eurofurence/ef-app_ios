//
//  WhenTheTutorialAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WellBehavedAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {

    var pushPermissionsAcknowledged: Bool = false

    func markPushPermissionsAsAcknowledged() {
        pushPermissionsAcknowledged = true
    }

}

struct UserNotAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {
    
    var pushPermissionsAcknowledged: Bool {
        return false
    }

    func markPushPermissionsAsAcknowledged() { }
    
}

struct UserAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {
    
    var pushPermissionsAcknowledged: Bool {
        return true
    }

    func markPushPermissionsAsAcknowledged() { }
    
}

class CapturingUserAcknowledgedPushPermissions: AcknowledgedPushPermissionsRequest {

    var pushPermissionsAcknowledged: Bool {
        return false
    }

    private(set) var didMarkUserAsAcknowledgingPushPermissionsRequest = false
    func markPushPermissionsAsAcknowledged() {
        didMarkUserAsAcknowledgingPushPermissionsRequest = true
    }

}

class CapturingPushPermissionsRequesting: PushPermissionsRequesting {

    private(set) var didRequestPermission = false
    private(set) var completionHandler: (() -> Void)?
    func requestPushPermissions(completionHandler: @escaping () -> Void) {
        didRequestPermission = true
        self.completionHandler = completionHandler
    }

    func completeRegistrationRequest() {
        completionHandler?()
    }

}

class CapturingUserOptedIntoPushNotifications: UserOptedIntoPushNotifications {

    private(set) var didPermitRegisteringForPushNotifications = false
    func markUserOptedIntoPushNotifications() {
        didPermitRegisteringForPushNotifications = true
    }

}

class WhenTheTutorialAppears: XCTestCase {

    struct TutorialTestContext {
        var tutorial: CapturingTutorialScene
        var page: CapturingTutorialPageScene
        var strings: PresentationStrings
        var assets: PresentationAssets
        var splashRouter: CapturingSplashScreenRouter
        var alertRouter: CapturingAlertRouter
        var tutorialStateProviding: StubFirstTimeLaunchStateProvider
        var pushRequesting: CapturingPushPermissionsRequesting
        var optedIntoPush: CapturingUserOptedIntoPushNotifications
    }

    private func showTutorial(_ networkReachability: NetworkReachability = ReachableWiFiNetwork(),
                              _ pushPermissionsRequestStateProviding: AcknowledgedPushPermissionsRequest = UserNotAcknowledgedPushPermissions()) -> TutorialTestContext {
        let tutorialRouter = CapturingTutorialRouter()
        let alertRouter = CapturingAlertRouter()
        let splashRouter = CapturingSplashScreenRouter()
        let stateProviding = StubFirstTimeLaunchStateProvider(userHasCompletedTutorial: false)
        let pushRequesting = CapturingPushPermissionsRequesting()
        let optedIntoPush = CapturingUserOptedIntoPushNotifications()
        let routers = StubRouters(tutorialRouter: tutorialRouter,
                                  splashScreenRouter: splashRouter,
                                  alertRouter: alertRouter)
        let context = PresentationTestBuilder()
            .withRouters(routers)
            .withUserCompletedTutorialStateProviding(stateProviding)
            .withUserAcknowledgedPushPermissionsRequest(pushPermissionsRequestStateProviding)
            .withNetworkReachability(networkReachability)
            .withPushPermissionsRequesting(pushRequesting)
            .withUserOptedIntoPushNotifications(optedIntoPush)
            .build()
        context.bootstrap()

        return TutorialTestContext(tutorial: tutorialRouter.tutorialScene,
                                   page: tutorialRouter.tutorialScene.tutorialPage,
                                   strings: context.presentationStrings,
                                   assets: context.presentationAssets,
                                   splashRouter: splashRouter,
                                   alertRouter: alertRouter,
                                   tutorialStateProviding: stateProviding,
                                   pushRequesting: pushRequesting,
                                   optedIntoPush: optedIntoPush)
    }
    
    private func showRequestPushPermissionsTutorialPage() -> TutorialTestContext {
        return showTutorial(ReachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
    }
    
    private func showBeginInitialDownloadTutorialPage(_ networkReachability: NetworkReachability = ReachableWiFiNetwork()) -> TutorialTestContext {
        let setup = showTutorial(networkReachability, UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        return setup
    }
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorial.wasToldToShowTutorialPage)
    }
    
    // MARK: Request push permissions page
    
    func testShowingThePushPermissionsRequestPageShouldSetThePushPermissionsTitleOntoTheTutorialPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        
        XCTAssertEqual(setup.strings.presentationString(for: .tutorialPushPermissionsRequestTitle),
                       setup.page.capturedPageTitle)
    }
    
    func testShowingThePushPermissionsRequestPageShouldSetThePushPermissionsDescriptionOntoTheTutorialPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        
        XCTAssertEqual(setup.strings.presentationString(for: .tutorialPushPermissionsRequestDescription),
                       setup.page.capturedPageDescription)
    }
    
    func testShowingThePushPermissionsRequestPageShouldSetThePushPermissionsImageOntoTheTutorialPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        
        XCTAssertEqual(setup.assets.requestPushNotificationPermissionsAsset,
                       setup.page.capturedPageImage)
    }

    func testShowingThePushPermissionsRequestPageShouldShowThePrimaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertTrue(setup.page.didShowPrimaryActionButton)
    }

    func testShowingThePushPermissionsRequestPageShouldSetTheAllowPushPermissionsStringOntoThePrimaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()

        XCTAssertEqual(setup.strings.presentationString(for: .tutorialAllowPushPermissions),
                       setup.page.capturedPrimaryActionDescription)
    }

    func testShowingThePushPermissionsRequestPageShouldShowTheSecondaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertTrue(setup.page.didShowSecondaryActionButton)
    }

    func testShowingThePushPermissionsRequestPageShouldSetTheDenyPushPermissionsStringOntoTheSecondaryActionButton() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertEqual(setup.strings.presentationString(for: .tutorialDenyPushPermissions),
                       setup.page.capturedSecondaryActionDescription)
    }

    func testShowingPushPermissionsRequestPageThenTappingSecondaryButtonShouldShowNewPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()

        XCTAssertEqual(2, setup.tutorial.numberOfPagesShown)
    }

    func testShowingPushPermissionsRequestPageThenTappingSecondaryButtonShouldNotShowNewPageUntilButtonIsActuallyTapped() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertEqual(1, setup.tutorial.numberOfPagesShown)
    }

    func testShowingPushPermissionsRequestPageThenTappingPrimaryButtonShouldRequestPushPermissions() {
        let setup = showRequestPushPermissionsTutorialPage()
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.pushRequesting.didRequestPermission)
    }

    func testShowingPushPermissionsRequestPageShouldNotImmediatleyRequestPushPermissions() {
        let setup = showRequestPushPermissionsTutorialPage()
        XCTAssertFalse(setup.pushRequesting.didRequestPermission)
    }

    func testTappingPrimaryButtonWhenRequestingPushPermissionsWithWifiShouldNotShowSplashScreen() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingPrimaryButtonWhenRequestingPushPermissionsWithoutWifiShouldNotShowAlert() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.alertRouter.didShowAlert)
    }

    func testRequestingPushPermissionsFinishesShouldShowNewPage() {
        let setup = showRequestPushPermissionsTutorialPage()
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()
        setup.pushRequesting.completeRegistrationRequest()

        XCTAssertEqual(2, setup.tutorial.numberOfPagesShown)
    }

    func testRequestingPushPermissionsFinishesShouldMarkUserAsAcknowledgingPushPermissions() {
        let capturingPushPermissions = CapturingUserAcknowledgedPushPermissions()
        let setup = showTutorial(UnreachableWiFiNetwork(), capturingPushPermissions)
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()
        setup.pushRequesting.completeRegistrationRequest()

        XCTAssertTrue(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }

    func testUserShouldNotBeMarkedAsAcknowledgingPushPermissionsUntilRequestCompletes() {
        let capturingPushPermissions = CapturingUserAcknowledgedPushPermissions()
        let setup = showTutorial(UnreachableWiFiNetwork(), capturingPushPermissions)
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertFalse(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }

    func testDenyingPushPermissionsShouldMarkUserAsAcknowledgingPushPermissions() {
        let capturingPushPermissions = CapturingUserAcknowledgedPushPermissions()
        let setup = showTutorial(UnreachableWiFiNetwork(), capturingPushPermissions)
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()

        XCTAssertTrue(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }

    func testAcceptingPushPermissionsShouldMarkUserAsAcceptingPushRegistrationRequest() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.optedIntoPush.didPermitRegisteringForPushNotifications)
    }

    func testAcceptingPushPermissionsShouldNotMarkUserAsAcceptingPushRegistrationRequestUntilThePrimaryButtonIsPressed() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
        XCTAssertFalse(setup.optedIntoPush.didPermitRegisteringForPushNotifications)
    }

    func testDenyingPushPermissionsShouldNotMarkUserAsAcceptingPushRegistrationRequest() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()

        XCTAssertFalse(setup.optedIntoPush.didPermitRegisteringForPushNotifications)
    }

    func testDenyingPushPermissionsThenBeginningDownloadShouldNotMarkUserAsRegisteringForNotifications() {
        let setup = showTutorial(UnreachableWiFiNetwork(), WellBehavedAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        setup.tutorial.tutorialPage.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.optedIntoPush.didPermitRegisteringForPushNotifications)
    }

    // MARK: Prepare for initial download page

    func testItShouldTellTheFirstTutorialPageToShowTheTitleForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadTitle),
                       setup.page.capturedPageTitle)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheDescriptionForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadDescription),
                       setup.page.capturedPageDescription)
    }

    func testItShouldShowTheInformationImageForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.assets.initialLoadInformationAsset,
                       setup.page.capturedPageImage)
    }
    
    func testItShouldShowThePrimaryActionButtonForTheInitiateDownloadTutorialPage() {
        let setup = showBeginInitialDownloadTutorialPage()
        XCTAssertTrue(setup.page.didShowPrimaryActionButton)
    }
    
    func testItShouldTellTheTutorialPageToShowTheBeginDownloadTextOnThePrimaryActionButton() {
        let setup = showBeginInitialDownloadTutorialPage()
        
        XCTAssertEqual(setup.strings.presentationString(for: .tutorialInitialLoadBeginDownload),
                       setup.page.capturedPrimaryActionDescription)
    }

    func testTappingThePrimaryButtonOnTheInitiateDownloadPageShouldNotRequestPushPermissions() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.pushRequesting.didRequestPermission)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableTellsSplashRouterToShowTheSplashScreen() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.splashRouter.wasToldToShowSplashScreen)
    }
    
    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableTellsTutorialCompletionProvidingToMarkTutorialAsComplete() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        
        XCTAssertTrue(setup.tutorialStateProviding.didMarkTutorialAsComplete)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlert() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableShouldNotTellSplashScreenRouterToShowTheSplashScreen() {
        let setup = showBeginInitialDownloadTutorialPage(UnreachableWiFiNetwork())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.splashRouter.wasToldToShowSplashScreen)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableDoesNotTellAlertRouterToShowAlert() {
        let setup = showBeginInitialDownloadTutorialPage(ReachableWiFiNetwork())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsTitle() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings.presentationString(for: .cellularDownloadAlertTitle),
                       setup.alertRouter.presentedAlertTitle)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsMessage() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings.presentationString(for: .cellularDownloadAlertMessage),
                       setup.alertRouter.presentedAlertMessage)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithContinueDownloadOverCellularAction() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.first

        XCTAssertEqual(setup.strings.presentationString(for: .cellularDownloadAlertContinueOverCellularTitle),
                       action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithCancelAction() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.last

        XCTAssertEqual(setup.strings.presentationString(for: .cancel),
                       action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableThenInvokingFirstActionShouldTellTheSplashRouterToShowTheSplashScreen() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        setup.alertRouter.presentedActions.first?.invoke()

        XCTAssertTrue(setup.splashRouter.wasToldToShowSplashScreen)
    }
    
    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableThenInvokingFirstActionShouldMarkTheTutorialAsComplete() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        setup.alertRouter.presentedActions.first?.invoke()
        
        XCTAssertTrue(setup.tutorialStateProviding.didMarkTutorialAsComplete)
    }

}
