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
}

protocol BuildConfigurationProviding {

}

protocol NotificationsService {

    func subscribeToTestNotifications()

}

struct StubBuildConfigurationProviding: BuildConfigurationProviding {

    var configuration: BuildConfiguration

}

class CapturingNotificationsService: NotificationsService {

    private(set) var subscribedToTestNotifications = false
    func subscribeToTestNotifications() {
        subscribedToTestNotifications = true
    }

}

struct EurofurenceApplication {

    init(buildConfiguration: BuildConfigurationProviding,
         notificationsService: NotificationsService) {
        notificationsService.subscribeToTestNotifications()
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
    
}
