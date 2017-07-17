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
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration,
                                                 loginController: CapturingLoginController(),
                                                 clock: StubClock())
        let deviceToken = Data()
        application.registerRemoteNotifications(deviceToken: deviceToken)

        XCTAssertEqual(deviceToken, capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
}
