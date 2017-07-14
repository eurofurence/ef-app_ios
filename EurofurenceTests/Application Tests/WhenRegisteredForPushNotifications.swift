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

    func subscribeToTestNotifications()
    func subscribeToLiveNotifications()

}

struct StubBuildConfigurationProviding: BuildConfigurationProviding {

    var configuration: BuildConfiguration

}

class CapturingNotificationsService: NotificationsService {

    private(set) var subscribedToTestNotifications = false
    func subscribeToTestNotifications() {
        subscribedToTestNotifications = true
    }

    private(set) var subscribedToLiveNotifications = false
    func subscribeToLiveNotifications() {
        subscribedToLiveNotifications = true
    }

}

struct EurofurenceApplication {

    init(buildConfiguration: BuildConfigurationProviding,
         notificationsService: NotificationsService) {
        switch buildConfiguration.configuration {
        case .debug:
            notificationsService.subscribeToTestNotifications()

        case .release:
            notificationsService.subscribeToLiveNotifications()
        }
    }

    func handleRemoteNotificationRegistration(deviceToken: Data) {

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
    
}
