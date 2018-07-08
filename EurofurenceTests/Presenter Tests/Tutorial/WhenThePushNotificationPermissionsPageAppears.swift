//
//  WhenThePushNotificationPermissionsPageAppears.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenThePushNotificationPermissionsPageAppears: XCTestCase {
    
    var context: TutorialModuleTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        context = TutorialModuleTestBuilder().with(UserNotAcknowledgedPushPermissions()).build()
    }
    
    func testThePushPermissionsTitleIsSetAsTheTitle() {
        XCTAssertEqual(.tutorialPushPermissionsRequestTitle,
                       context.page.capturedPageTitle)
    }
    
    func testThePushPermissionsDescriptionIsSetAsTheDescription() {
        XCTAssertEqual(.tutorialPushPermissionsRequestDescription,
                       context.page.capturedPageDescription)
    }
    
    func testThePushPermissionsImageIsSetAsThePageImage() {
        XCTAssertEqual(context.assets.requestPushNotificationPermissionsAsset,
                       context.page.capturedPageImage)
    }
    
    func testThePrimaryActionButtonShouldAppear() {
        XCTAssertTrue(context.page.didShowPrimaryActionButton)
    }
    
    func testThePrimaryActionButtonShouldHaveTheAllowPushPermissionsStringAsTheTitle() {
        XCTAssertEqual(.tutorialAllowPushPermissions,
                       context.page.capturedPrimaryActionDescription)
    }
    
    func testTheSecondaryActionButtonShouldAppear() {
        XCTAssertTrue(context.page.didShowSecondaryActionButton)
    }
    
    func testTheSecondaryActionButtonShouldHaveTheDenyPushPermissionsStringAsTheTitle() {
        XCTAssertEqual(.tutorialDenyPushPermissions,
                       context.page.capturedSecondaryActionDescription)
    }
    
    func testTappingSecondaryButtonShouldShowNewPage() {
        context.tapSecondaryButton()
        XCTAssertEqual(2, context.tutorial.numberOfPagesShown)
    }
    
    func testTappingSecondaryButtonShouldNotShowNewPageUntilButtonIsTapped() {
        XCTAssertEqual(1, context.tutorial.numberOfPagesShown)
    }
    
    func testTappingPrimaryButtonShouldRequestPushPermissions() {
        context.tapPrimaryButton()
        XCTAssertTrue(context.pushRequesting.wasToldToRequestPushPermissions)
    }
    
    func testPushPermissionsShouldNotBeRequestedWithoutUserInteraction() {
        XCTAssertFalse(context.pushRequesting.wasToldToRequestPushPermissions)
    }
    
    func testRequestingPushPermissionsShouldNotCompleteTutorial() {
        context.tapPrimaryButton()
        XCTAssertFalse(context.delegate.wasToldTutorialFinished)
    }
    
    func testPushRequestCompletesTransitionsToNewPage() {
        context.tapPrimaryButton()
        context.pushRequesting.completeRegistrationRequest()
        
        XCTAssertEqual(2, context.tutorial.numberOfPagesShown)
    }
    
}
