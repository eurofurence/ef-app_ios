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
    
    func testForDebugConfigurationTestNotificationsShouldBeSubscribed() {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: .debug)
        let capturingNotificationService = CapturingNotificationsService()
        let app = EurofurenceApplication(buildConfiguration: buildConfigurationProviding,
                                         notificationsService: capturingNotificationService)
        app.handleRemoteNotificationRegistration(deviceToken: Data())

        XCTAssertTrue(capturingNotificationService.subscribedToTestNotifications)
    }

    func testForReleaseConfigurationLiveNotificationsShouldBeSubscribed() {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: .release)
        let capturingNotificationService = CapturingNotificationsService()
        let app = EurofurenceApplication(buildConfiguration: buildConfigurationProviding,
                                         notificationsService: capturingNotificationService)
        app.handleRemoteNotificationRegistration(deviceToken: Data())

        XCTAssertTrue(capturingNotificationService.subscribedToLiveNotifications)
    }

    func testForDebugConfigurationLiveNotificationsShouldNotBeSubscribed() {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: .debug)
        let capturingNotificationService = CapturingNotificationsService()
        let app = EurofurenceApplication(buildConfiguration: buildConfigurationProviding,
                                         notificationsService: capturingNotificationService)
        app.handleRemoteNotificationRegistration(deviceToken: Data())

        XCTAssertFalse(capturingNotificationService.subscribedToLiveNotifications)
    }

    func testForReleaseConfigurationTestNotificationsShouldNotBeSubscribed() {
        let buildConfigurationProviding = StubBuildConfigurationProviding(configuration: .release)
        let capturingNotificationService = CapturingNotificationsService()
        let app = EurofurenceApplication(buildConfiguration: buildConfigurationProviding,
                                         notificationsService: capturingNotificationService)
        app.handleRemoteNotificationRegistration(deviceToken: Data())

        XCTAssertFalse(capturingNotificationService.subscribedToTestNotifications)
    }
    
}
