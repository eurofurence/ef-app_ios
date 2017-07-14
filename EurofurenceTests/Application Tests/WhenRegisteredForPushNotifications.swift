//
//  WhenRegisteredForPushNotifications.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

enum BuildConfiguration {
    case debug
    case release
}

protocol BuildConfigurationProviding {

    var configuration: BuildConfiguration { get }

}

protocol NotificationsService {

    func register(deviceToken: Data)

    func subscribeToTestNotifications()
    func unsubscribeFromTestNotifications()

    func subscribeToLiveNotifications()
    func unsubscribeFromLiveNotifications()

}

struct StubBuildConfigurationProviding: BuildConfigurationProviding {

    var configuration: BuildConfiguration

}

class CapturingNotificationsService: NotificationsService {

    private(set) var registeredDeviceToken: Data?
    func register(deviceToken: Data) {
        registeredDeviceToken = deviceToken
    }

    private(set) var subscribedToTestNotifications = false
    func subscribeToTestNotifications() {
        subscribedToTestNotifications = true
    }

    private(set) var unsubscribedFromTestNotifications = false
    func unsubscribeFromTestNotifications() {
        unsubscribedFromTestNotifications = true
    }

    private(set) var subscribedToLiveNotifications = false
    func subscribeToLiveNotifications() {
        subscribedToLiveNotifications = true
    }

    private(set) var unsubscribedFromLiveNotifications = false
    func unsubscribeFromLiveNotifications() {
        unsubscribedFromLiveNotifications = true
    }

}

struct EurofurenceApplication {

    private var buildConfiguration: BuildConfigurationProviding
    private var notificationsService: NotificationsService

    init(buildConfiguration: BuildConfigurationProviding,
         notificationsService: NotificationsService) {
        self.buildConfiguration = buildConfiguration
        self.notificationsService = notificationsService
    }

    func handleRemoteNotificationRegistration(deviceToken: Data) {
        notificationsService.register(deviceToken: deviceToken)

        switch buildConfiguration.configuration {
        case .debug:
            notificationsService.subscribeToTestNotifications()
            notificationsService.unsubscribeFromLiveNotifications()
        case .release:
            notificationsService.subscribeToLiveNotifications()
            notificationsService.unsubscribeFromTestNotifications()
        }
    }

}

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
