//
//  WhenThePushNotificationPermissionsPageAppearsWithUnreachableNetwork.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 19/12/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenThePushNotificationPermissionsPageAppearsWithUnreachableNetwork: XCTestCase {
    
    var context: TutorialModuleTestBuilder.Context!
    var capturingPushPermissions: CapturingUserAcknowledgedPushPermissions!
    
    override func setUp() {
        super.setUp()
        
        capturingPushPermissions = CapturingUserAcknowledgedPushPermissions()
        context = TutorialModuleTestBuilder()
            .with(UnreachableWiFiNetwork())
            .with(capturingPushPermissions)
            .build()
    }
    
    func testTappingPrimaryButtonWhenRequestingPushPermissionsWithoutWifiShouldNotShowAlert() {
        context.tapPrimaryButton()
        XCTAssertFalse(context.alertRouter.didShowAlert)
    }
    
    func testRequestingPushPermissionsFinishesShouldMarkUserAsAcknowledgingPushPermissions() {
        context.tapPrimaryButton()
        context.pushRequesting.completeRegistrationRequest()
        
        XCTAssertTrue(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }
    
    func testUserShouldNotBeMarkedAsAcknowledgingPushPermissionsUntilRequestCompletes() {
        context.tapPrimaryButton()
        XCTAssertFalse(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }
    
    func testDenyingPushPermissionsShouldMarkUserAsAcknowledgingPushPermissions() {
        context.tapSecondaryButton()
        XCTAssertTrue(capturingPushPermissions.didMarkUserAsAcknowledgingPushPermissionsRequest)
    }
    
}
