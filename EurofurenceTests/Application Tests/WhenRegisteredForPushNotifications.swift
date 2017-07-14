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

    struct NotificationsRegistrationTestContext {
        var app: EurofurenceApplication
        var capturingNotificationService: CapturingNotificationsService

        func registerForNotifications(deviceToken: Data = Data()) {
            app.handleRemoteNotificationRegistration(deviceToken: deviceToken)
        }
    }

    private func assembleApp(configuration: BuildConfiguration) -> NotificationsRegistrationTestContext {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: configuration)
        let capturingNotificationService = CapturingNotificationsService()
        let app = EurofurenceApplication(buildConfiguration: buildConfigurationProviding,
                                         notificationsService: capturingNotificationService)

        return NotificationsRegistrationTestContext(app: app,
                                                    capturingNotificationService: capturingNotificationService)
    }
    
    func testForDebugConfigurationTestNotificationsShouldBeSubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerForNotifications()

        XCTAssertTrue(context.capturingNotificationService.subscribedToTestNotifications)
    }

    func testForReleaseConfigurationLiveNotificationsShouldBeSubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerForNotifications()

        XCTAssertTrue(context.capturingNotificationService.subscribedToLiveNotifications)
    }

    func testForDebugConfigurationLiveNotificationsShouldNotBeSubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerForNotifications()

        XCTAssertFalse(context.capturingNotificationService.subscribedToLiveNotifications)
    }

    func testForReleaseConfigurationTestNotificationsShouldNotBeSubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerForNotifications()

        XCTAssertFalse(context.capturingNotificationService.subscribedToTestNotifications)
    }

    func testForDebugConfigurationLiveNotificationsShouldBeUnsubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerForNotifications()

        XCTAssertTrue(context.capturingNotificationService.unsubscribedFromLiveNotifications)
    }

    func testForReleaseConfigurationTestNotificationsShouldBeUnsubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerForNotifications()

        XCTAssertTrue(context.capturingNotificationService.unsubscribedFromTestNotifications)
    }

    func testForDebugConfigurationTestNotificationsShouldNotBeUnsubscribed() {
        let context = assembleApp(configuration: .debug)
        context.registerForNotifications()

        XCTAssertFalse(context.capturingNotificationService.unsubscribedFromTestNotifications)
    }

    func testForReleaseConfigurationLiveNotificationsShouldNotBeUnsubscribed() {
        let context = assembleApp(configuration: .release)
        context.registerForNotifications()

        XCTAssertFalse(context.capturingNotificationService.unsubscribedFromLiveNotifications)
    }

    func testForDebugConfigurationNotRegisterForTestNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .debug)
        XCTAssertFalse(context.capturingNotificationService.subscribedToTestNotifications)
    }

    func testForReleaseConfigurationNotRegisterForLiveNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .release)
        XCTAssertFalse(context.capturingNotificationService.subscribedToLiveNotifications)
    }

    func testForDebugConfigurationNotUnregisterFromLiveNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .debug)
        XCTAssertFalse(context.capturingNotificationService.unsubscribedFromLiveNotifications)
    }

    func testForReleaseConfigurationNotUnregisterFromTestNotificationsUntilWeActuallyReceievePushToken() {
        let context = assembleApp(configuration: .release)
        XCTAssertFalse(context.capturingNotificationService.unsubscribedFromTestNotifications)
    }

    func testSetTheTokenOntoTheNotificationsService() {
        let context = assembleApp(configuration: .debug)
        let deviceToken = "I'm a token".data(using: .utf8)!
        context.registerForNotifications(deviceToken: deviceToken)

        XCTAssertEqual(deviceToken, context.capturingNotificationService.registeredDeviceToken)
    }
    
}
