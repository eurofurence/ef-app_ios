//
//  FirebaseMessagingAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import FirebaseMessaging
import Foundation

public struct FirebaseMessagingAdapter: FirebaseAdapter {

    private let messaging = Messaging.messaging()

    public var fcmToken: String {
        return messaging.fcmToken ?? ""
    }

    public func setAPNSToken(deviceToken: Data?) {
        messaging.apnsToken = deviceToken
    }

    public func subscribe(toTopic topic: FirebaseTopic) {
        messaging.subscribe(toTopic: topic.description)
    }

    public func unsubscribe(fromTopic topic: FirebaseTopic) {
        messaging.unsubscribe(fromTopic: topic.description)
    }

}
