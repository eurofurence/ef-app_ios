//
//  WhenThePerformInitialDownloadPageAppearsWithUnreachableNetwork.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenThePerformInitialDownloadPageAppearsWithUnreachableNetwork: XCTestCase {
    
    var context: TutorialModuleTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = TutorialModuleTestBuilder()
            .with(UnreachableWiFiNetwork())
            .with(UserAcknowledgedPushPermissions())
            .build()
    }
    
    func testTappingThePrimaryButtonTellsAlertRouterToShowAlert() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertTrue(context.alertRouter.didShowAlert)
    }
    
    func testTappingThePrimaryButtonShouldNotCompleteTutorial() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertFalse(context.delegate.wasToldTutorialFinished)
    }
    
    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsTitle() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertEqual(context.strings[.cellularDownloadAlertTitle],
                       context.alertRouter.presentedAlertTitle)
    }
    
    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithWarnUserAboutCellularDownloadsMessage() {
        context.page.simulateTappingPrimaryActionButton()
        XCTAssertEqual(context.strings[.cellularDownloadAlertMessage],
                       context.alertRouter.presentedAlertMessage)
    }
    
    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithContinueDownloadOverCellularAction() {
        context.page.simulateTappingPrimaryActionButton()
        let action = context.alertRouter.presentedActions.first
        
        XCTAssertEqual(context.strings[.cellularDownloadAlertContinueOverCellularTitle],
                       action?.title)
    }
    
    func testTappingThePrimaryButtonTellsAlertRouterToShowAlertWithCancelAction() {
        context.page.simulateTappingPrimaryActionButton()
        let action = context.alertRouter.presentedActions.last
        
        XCTAssertEqual(context.strings[.cancel], action?.title)
    }
    
    func testTappingThePrimaryButtonThenInvokingFirstActionShouldTellTheDelegateTheTutorialFinished() {
        context.page.simulateTappingPrimaryActionButton()
        context.alertRouter.presentedActions.first?.invoke()
        
        XCTAssertTrue(context.delegate.wasToldTutorialFinished)
    }
    
    func testTappingThePrimaryButtonThenInvokingFirstActionShouldMarkTheTutorialAsComplete() {
        context.page.simulateTappingPrimaryActionButton()
        context.alertRouter.presentedActions.first?.invoke()
        
        XCTAssertTrue(context.tutorialStateProviding.didMarkTutorialAsComplete)
    }
    
}
