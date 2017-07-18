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
    
    struct Context {
        var application: EurofurenceApplication
        var capturingLoginController: CapturingLoginController
        var capturingTokenRegistration: CapturingRemoteNotificationsTokenRegistration
        
        func registerRemoteNotifications(_ deviceToken: Data = Data()) {
            application.registerRemoteNotifications(deviceToken: deviceToken)
        }
        
        func notifyUserLoggedIn(_ token: String = "", expires: Date = .distantFuture) {
            capturingLoginController.notifyUserLoggedIn(token, expires: expires)
        }
    }
    
    private func buildTestCase(currentDate: Date = Date()) -> Context {
        let capturingLoginController = CapturingLoginController()
        let capturingTokenRegistration = CapturingRemoteNotificationsTokenRegistration()
        let application = EurofurenceApplication(remoteNotificationsTokenRegistration: capturingTokenRegistration,
                                                 loginController: capturingLoginController,
                                                 clock: StubClock(currentDate: currentDate))
        return Context(application: application,
                       capturingLoginController: capturingLoginController,
                       capturingTokenRegistration: capturingTokenRegistration)
    }
    
    func testLoggingInShouldReregisterPushDeviceTokenAfterOneWasRegistered() {
        let context = buildTestCase()
        context.registerRemoteNotifications()
        context.notifyUserLoggedIn()
        
        XCTAssertEqual(2, context.capturingTokenRegistration.numberOfRegistrations)
    }
    
    func testLoggingInShouldReregisterTheSamePushDeviceToken() {
        let context = buildTestCase()
        let deviceToken = "Token".data(using: .utf8)!
        context.registerRemoteNotifications(deviceToken)
        context.notifyUserLoggedIn()
        
        XCTAssertEqual(deviceToken, context.capturingTokenRegistration.capturedRemoteNotificationsDeviceToken)
    }
    
    func testLoggingInShouldReregisterTheUserAuthenticationToken() {
        let context = buildTestCase()
        context.registerRemoteNotifications()
        let authenticationToken = "JWT Token"
        context.notifyUserLoggedIn(authenticationToken)
        
        XCTAssertEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testBeingLoggedInOnLaunchShouldRegisterTheExistingTokenWhenPushTokenRegistrationOccurs() {
        let authenticationToken = "JWT Token"
        let context = buildTestCase()
        context.notifyUserLoggedIn(authenticationToken)
        let deviceToken = Data()
        context.registerRemoteNotifications(deviceToken)
        
        XCTAssertEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
    func testBeingLoggedInOnLaunchShouldNotRegisterTheExistingTokenWhenTheTokenExpired() {
        let authenticationToken = "JWT Token"
        let expirationDate = Date()
        let simulatedDate = expirationDate.addingTimeInterval(1)
        let context = buildTestCase(currentDate: simulatedDate)
        context.notifyUserLoggedIn(authenticationToken, expires: expirationDate)
        context.registerRemoteNotifications()
        
        XCTAssertNotEqual(authenticationToken, context.capturingTokenRegistration.capturedUserAuthenticationToken)
    }
    
}
