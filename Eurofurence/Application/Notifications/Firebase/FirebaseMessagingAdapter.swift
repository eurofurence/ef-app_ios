//
//  FirebaseMessagingAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import FirebaseMessaging
import Foundation

struct FirebaseMessagingAdapter: FirebaseAdapter {

    private let messaging = Messaging.messaging()

    var fcmToken: String {
        return messaging.fcmToken ?? ""
    }

    func setAPNSToken(deviceToken: Data) {
        messaging.setAPNSToken(deviceToken, type: .unknown)
    }

    func subscribe(toTopic topic: FirebaseTopic) {
        messaging.subscribe(toTopic: topic.description)
    }

    func unsubscribe(fromTopic topic: FirebaseTopic) {
        messaging.unsubscribe(fromTopic: topic.description)
    }

}
