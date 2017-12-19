//
//  WhenTheTutorialAppears.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 09/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubTutorialSceneFactory: TutorialSceneFactory {
    
    let tutorialScene = CapturingTutorialScene()
    func makeTutorialScene() -> UIViewController & TutorialScene {
        return tutorialScene
    }
    
}

class CapturingTutorialModuleDelegate: TutorialModuleDelegate {
    
    private(set) var wasToldTutorialFinished = false
    func tutorialModuleDidFinishPresentingTutorial() {
        wasToldTutorialFinished = true
    }
    
}

class WhenTheTutorialAppears: XCTestCase {

    private func showTutorial(_ networkReachability: NetworkReachability = ReachableWiFiNetwork(),
                              _ pushPermissionsRequestStateProviding: WitnessedTutorialPushPermissionsRequest = UserNotAcknowledgedPushPermissions()) -> TutorialModuleTestBuilder.Context {
        return TutorialModuleTestBuilder().with(networkReachability).with(pushPermissionsRequestStateProviding).build()
    }
    
    private func showRequestPushPermissionsTutorialPage() -> TutorialModuleTestBuilder.Context {
        return showTutorial(ReachableWiFiNetwork(), UserNotAcknowledgedPushPermissions())
    }
    
    private func showBeginInitialDownloadTutorialPage(_ networkReachability: NetworkReachability = ReachableWiFiNetwork()) -> TutorialModuleTestBuilder.Context {
        let setup = showTutorial(networkReachability, UserNotAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        return setup
    }
    
    func testItShouldBeToldToShowTheTutorialPage() {
        let setup = showTutorial()
        XCTAssertTrue(setup.tutorial.wasToldToShowTutorialPage)
    }
    
    func testItShouldReturnTheViewControllerFromTheFactory() {
        let setup = showTutorial()
        XCTAssertEqual(setup.tutorialViewController, setup.tutorial)
    }
    
    // MARK: Prepare for initial download page

    func testItShouldTellTheFirstTutorialPageToShowTheTitleForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.strings[.tutorialInitialLoadTitle],
                       setup.page.capturedPageTitle)
    }

    func testItShouldTellTheFirstTutorialPageToShowTheDescriptionForBeginningInitialLoad() {
        let setup = showBeginInitialDownloadTutorialPage()

        XCTAssertEqual(setup.strings[.tutorialInitialLoadDescription],
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
        
        XCTAssertEqual(setup.strings[.tutorialInitialLoadBeginDownload],
                       setup.page.capturedPrimaryActionDescription)
    }

    func testTappingThePrimaryButtonOnTheInitiateDownloadPageShouldNotRequestPushPermissions() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.tutorial.tutorialPage.simulateTappingSecondaryActionButton()
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.pushRequesting.didRequestPermission)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableTellsTutorialDelegateTutorialFinished() {
        let setup = showTutorial(ReachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertTrue(setup.delegate.wasToldTutorialFinished)
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

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableShouldNotCompleteTutorial() {
        let setup = showBeginInitialDownloadTutorialPage(UnreachableWiFiNetwork())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.delegate.wasToldTutorialFinished)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiAvailableDoesNotTellAlertRouterToShowAlert() {
        let setup = showBeginInitialDownloadTutorialPage(ReachableWiFiNetwork())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertFalse(setup.alertRouter.didShowAlert)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsTitle() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings[.cellularDownloadAlertTitle],
                       setup.alertRouter.presentedAlertTitle)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsMessage() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()

        XCTAssertEqual(setup.strings[.cellularDownloadAlertMessage],
                       setup.alertRouter.presentedAlertMessage)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithContinueDownloadOverCellularAction() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.first

        XCTAssertEqual(setup.strings[.cellularDownloadAlertContinueOverCellularTitle],
                       action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableTellsAlertRouterToShowAlertWithCancelAction() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        let action = setup.alertRouter.presentedActions.last

        XCTAssertEqual(setup.strings[.cancel], action?.title)
    }

    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableThenInvokingFirstActionShouldTellTheDelegateTheTutorialFinished() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        setup.alertRouter.presentedActions.first?.invoke()

        XCTAssertTrue(setup.delegate.wasToldTutorialFinished)
    }
    
    func testTappingThePrimaryButtonWhenReachabilityIndicatesWiFiUnavailableThenInvokingFirstActionShouldMarkTheTutorialAsComplete() {
        let setup = showTutorial(UnreachableWiFiNetwork(), UserAcknowledgedPushPermissions())
        setup.page.simulateTappingPrimaryActionButton()
        setup.alertRouter.presentedActions.first?.invoke()
        
        XCTAssertTrue(setup.tutorialStateProviding.didMarkTutorialAsComplete)
    }

}
