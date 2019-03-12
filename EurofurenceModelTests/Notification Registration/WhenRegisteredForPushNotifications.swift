//
//  WhenRegisteredForPushNotifications.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRegisteredForPushNotifications: XCTestCase {

    func testTheApplicationTellsTheRemoteNotificationRegistrationItRegisteredWithTheDeviceToken() {
        let context = EurofurenceSessionTestBuilder().build()
        let deviceToken = Data()
        context.notificationsService.storeRemoteNotificationsToken(deviceToken)

        XCTAssertEqual(deviceToken, context.notificationTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }

    func testLaunchingAppRequestsPushPermissions() {
        let permissionsRequester = CapturingPushPermissionsRequester()
        EurofurenceSessionTestBuilder().with(permissionsRequester).build()

        XCTAssertTrue(permissionsRequester.wasToldToRequestPushPermissions)
    }

}
