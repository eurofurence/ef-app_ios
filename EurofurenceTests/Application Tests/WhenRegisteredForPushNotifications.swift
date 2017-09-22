//
//  WhenRegisteredForPushNotifications.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenRegisteredForPushNotifications: XCTestCase {

    func testTheApplicationTellsTheRemoteNotificationRegistrationItRegisteredWithTheDeviceToken() {
        let context = ApplicationTestBuilder().build()
        let deviceToken = Data()
        context.application.storeRemoteNotificationsToken(deviceToken)

        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testRequestingPushPermissionsTellsThePushRequesterToRequestPermissions() {
        let permissionsRequester = CapturingPushPermissionsRequester()
        let context = ApplicationTestBuilder().with(permissionsRequester).build()
        context.application.requestPermissionsForPushNotifications()
        
        XCTAssertTrue(permissionsRequester.wasToldToRequestPushPermissions)
    }
    
    func testRequestingPushPermissionsMarksPushPermissionsWitness() {
        let witnessedSystemPushes = CapturingPushPermissionsStateProviding()
        witnessedSystemPushes.requestedPushNotificationAuthorization = false
        let context = ApplicationTestBuilder().with(witnessedSystemPushes).build()
        context.application.requestPermissionsForPushNotifications()
        
        XCTAssertTrue(witnessedSystemPushes.didPermitRegisteringForPushNotifications)
    }
    
    func testWitnessedPushPermissionsStoreIsNotToldAboutItUntilRequestingPushPermissions() {
        let witnessedSystemPushes = CapturingPushPermissionsStateProviding()
        witnessedSystemPushes.requestedPushNotificationAuthorization = false
        ApplicationTestBuilder().with(witnessedSystemPushes).build()
        
        XCTAssertFalse(witnessedSystemPushes.didPermitRegisteringForPushNotifications)
    }
    
    func testLaunchingTheAppWhenPushPermissionsNotRequestedBeforeShouldNotRequestPermissionAutomatically() {
        let permissionsRequester = CapturingPushPermissionsRequester()
        let witnessedSystemPushes = CapturingPushPermissionsStateProviding()
        witnessedSystemPushes.requestedPushNotificationAuthorization = false
        ApplicationTestBuilder().with(permissionsRequester).with(witnessedSystemPushes).build()
        
        XCTAssertFalse(permissionsRequester.wasToldToRequestPushPermissions)
    }
    
    func testLaunchingTheAppWhenPushPermissionsRequestedBeforeShouldRequestPermissionAutomatically() {
        let permissionsRequester = CapturingPushPermissionsRequester()
        let witnessedSystemPushes = CapturingPushPermissionsStateProviding()
        witnessedSystemPushes.requestedPushNotificationAuthorization = true
        ApplicationTestBuilder().with(permissionsRequester).with(witnessedSystemPushes).build()
        
        XCTAssertTrue(permissionsRequester.wasToldToRequestPushPermissions)
    }
    
}
