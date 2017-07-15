//
//  FirebaseNotificationsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import FirebaseMessaging
import Foundation

struct FirebaseNotificationsService: NotificationsService {

    private let messaging = Messaging.messaging()

    func register(deviceToken: Data) {
        messaging.setAPNSToken(deviceToken, type: .unknown)
    }

    func subscribeToTestNotifications() {
        messaging.subscribe(toTopic: "test")
    }

    func unsubscribeFromTestNotifications() {
        messaging.unsubscribe(fromTopic: "test")
    }

    func subscribeToLiveNotifications() {
        messaging.subscribe(toTopic: "live")
    }

    func unsubscribeFromLiveNotifications() {
        messaging.unsubscribe(fromTopic: "live")
    }

    func subscribeToAnnouncements() {
        messaging.subscribe(toTopic: "announcements")
    }

}
