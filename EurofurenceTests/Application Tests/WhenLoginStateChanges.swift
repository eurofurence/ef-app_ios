//
//  WhenLoginStateChanges.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 17/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenLoginStateChanges: XCTestCase {
    
    func testLoggingInShouldReregisterPushDeviceTokenAfterOneWasRegistered() {
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration, loginController: capturingLoginController, clock: StubClock())
        let deviceToken = Data()
        application.registerRemoteNotifications(deviceToken: deviceToken)
        capturingLoginController.notifyUserLoggedIn()
        
        XCTAssertEqual(2, capturingTokenRegistration.numberOfRegistrations)
    }
    
    func testLoggingInShouldReregisterTheSamePushDeviceToken() {
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration, loginController: capturingLoginController, clock: StubClock())
        let deviceToken = "Token".data(using: .utf8)!
        application.registerRemoteNotifications(deviceToken: deviceToken)
        capturingLoginController.notifyUserLoggedIn()
        
        XCTAssertEqual(deviceToken, capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testLoggingInShouldReregisterTheUserAuthenticationToken() {
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration, loginController: capturingLoginController, clock: StubClock())
        let deviceToken = Data()
        application.registerRemoteNotifications(deviceToken: deviceToken)
        let authenticationToken = "JWT Token"
        capturingLoginController.notifyUserLoggedIn(authenticationToken)
        
        XCTAssertEqual(authenticationToken, capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testBeingLoggedInOnLaunchShouldRegisterTheExistingTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration, loginController: capturingLoginController, clock: StubClock())
        capturingLoginController.notifyUserLoggedIn(authenticationToken)
        let deviceToken = Data()
        application.registerRemoteNotifications(deviceToken: deviceToken)
        
        XCTAssertEqual(authenticationToken, capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testBeingLoggedInOnLaunchShouldNotRegisterTheExistingTokenWhenTheTokenExpired() {
        let authenticationToken = "JWT Token"
        let expirationDate = Date()
        let simulatedDate = expirationDate.addingTimeInterval(1)
        let clock = StubClock(currentDate: simulatedDate)
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration,
                                                 loginController: capturingLoginController,
                                                 clock: clock)
        capturingLoginController.notifyUserLoggedIn(authenticationToken, expires: expirationDate)
        let deviceToken = Data()
        application.registerRemoteNotifications(deviceToken: deviceToken)
        
        XCTAssertNotEqual(authenticationToken, capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
}
