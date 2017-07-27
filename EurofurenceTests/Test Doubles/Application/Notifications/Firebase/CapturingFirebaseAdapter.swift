//
//  CapturingFirebaseAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingFirebaseAdapter: FirebaseAdapter {

    private(set) var registeredDeviceToken: Data?
    func setAPNSToken(deviceToken: Data) {
        registeredDeviceToken = deviceToken
    }

    private var subscribedTopics = [FirebaseTopic]()
    func subscribe(toTopic topic: FirebaseTopic) {
        subscribedTopics.append(topic)
    }

    private var unsubscribedTopics = [FirebaseTopic]()
    func unsubscribe(fromTopic topic: FirebaseTopic) {
        unsubscribedTopics.append(topic)
    }

    var fcmToken: String = ""

    func didSubscribeToTopic(_ topic: FirebaseTopic) -> Bool {
        return subscribedTopics.contains(topic)
    }

    func didUnsubscribeFromTopic(_ topic: FirebaseTopic) -> Bool {
        return unsubscribedTopics.contains(topic)
    }

    var subscribedToTestNotifications: Bool {
        return didSubscribeToTopic(.test)
    }
    
    var subscribedToTestAllNotifications: Bool {
        return didSubscribeToTopic(.testAll)
    }

    var subscribedToLiveNotifications: Bool {
        return didSubscribeToTopic(.live)
    }
    
    var subscribedToLiveAllNotifications: Bool {
        return didSubscribeToTopic(.liveAll)
    }

    var unsubscribedFromTestNotifications: Bool {
        return didUnsubscribeFromTopic(.test)
    }
    
    var unsubscribedFromTestAllNotifications: Bool {
        return didUnsubscribeFromTopic(.testAll)
    }

    var unsubscribedFromLiveNotifications: Bool {
        return didUnsubscribeFromTopic(.live)
    }
    
    var unsubscribedFromLiveAllNotifications: Bool {
        return didUnsubscribeFromTopic(.liveAll)
    }

    var subscribedToAnnouncements: Bool {
        return didSubscribeToTopic(.announcements)
    }
    
}
