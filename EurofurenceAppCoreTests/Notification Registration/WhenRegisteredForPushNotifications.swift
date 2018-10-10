//
//  WhenRegisteredForPushNotifications.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenRegisteredForPushNotifications: XCTestCase {

    func testTheApplicationTellsTheRemoteNotificationRegistrationItRegisteredWithTheDeviceToken() {
        let context = ApplicationTestBuilder().build()
        let deviceToken = Data()
        context.application.storeRemoteNotificationsToken(deviceToken)

        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testLaunchingAppRequestsPushPermissions() {
        let permissionsRequester = CapturingPushPermissionsRequester()
        ApplicationTestBuilder().with(permissionsRequester).build()
        
        XCTAssertTrue(permissionsRequester.wasToldToRequestPushPermissions)
    }
    
}
