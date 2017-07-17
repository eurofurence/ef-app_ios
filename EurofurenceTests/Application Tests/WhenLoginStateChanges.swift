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
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration, loginController: capturingLoginController)
        let deviceToken = Data()
        application.registerRemoteNotifications(deviceToken: deviceToken)
        capturingLoginController.notifyUserLoggedIn()
        
        XCTAssertEqual(2, capturingTokenRegistration.numberOfRegistrations)
    }
    
    func testLoggingInShouldReregisterTheSamePushDeviceToken() {
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration, loginController: capturingLoginController)
        let deviceToken = "Token".data(using: .utf8)!
        application.registerRemoteNotifications(deviceToken: deviceToken)
        capturingLoginController.notifyUserLoggedIn()
        
        XCTAssertEqual(deviceToken, capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testLoggingInShouldReregisterTheUserAuthenticationToken() {
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration, loginController: capturingLoginController)
        let deviceToken = Data()
        application.registerRemoteNotifications(deviceToken: deviceToken)
        let authenticationToken = "JWT Token"
        capturingLoginController.notifyUserLoggedIn(authenticationToken)
        
        XCTAssertEqual(authenticationToken, capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
}
