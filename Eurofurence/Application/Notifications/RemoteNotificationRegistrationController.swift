//
//  RemoteNotificationRegistrationController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/01/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class RemoteNotificationRegistrationController {

    private let remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?
    private var deviceToken: Data?
    private var authenticationToken: String?

    init(eventBus: EventBus,
         remoteNotificationsTokenRegistration: RemoteNotificationsTokenRegistration?) {
        self.remoteNotificationsTokenRegistration = remoteNotificationsTokenRegistration

        eventBus.subscribe(consumer: BlockEventConsumer(block: remoteNotificationRegistrationSucceeded))
        eventBus.subscribe(consumer: BlockEventConsumer(block: userDidLogin))
    }

    private func reregisterNotificationToken() {
        remoteNotificationsTokenRegistration?.registerRemoteNotificationsDeviceToken(deviceToken, userAuthenticationToken: authenticationToken) { (_) in

        }
    }

    private func remoteNotificationRegistrationSucceeded(_ event: DomainEvent.RemoteNotificationRegistrationSucceeded) {
        deviceToken = event.deviceToken
        reregisterNotificationToken()
    }

    private func userDidLogin(_ event: DomainEvent.LoggedIn) {
        authenticationToken = event.authenticationToken
        reregisterNotificationToken()
    }

}
