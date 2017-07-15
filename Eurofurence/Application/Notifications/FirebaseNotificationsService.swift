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

    private enum Topic: String {
        case test
        case live
        case announcements
    }

    func register(deviceToken: Data) {
        messaging.setAPNSToken(deviceToken, type: .unknown)
    }

    func subscribeToTestNotifications() {
        messaging.subscribe(toTopic: Topic.test.rawValue)
    }

    func unsubscribeFromTestNotifications() {
        messaging.unsubscribe(fromTopic: Topic.test.rawValue)
    }

    func subscribeToLiveNotifications() {
        messaging.subscribe(toTopic: Topic.live.rawValue)
    }

    func unsubscribeFromLiveNotifications() {
        messaging.unsubscribe(fromTopic: Topic.live.rawValue)
    }

    func subscribeToAnnouncements() {
        messaging.subscribe(toTopic: Topic.announcements.rawValue)
    }

}
