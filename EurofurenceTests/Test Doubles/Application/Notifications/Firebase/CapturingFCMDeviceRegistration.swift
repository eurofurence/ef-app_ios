//
//  CapturingFCMDeviceRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingFCMDeviceRegistration: FCMDeviceRegistration {

    private(set) var capturedFCM: String?
    private var topics = [FirebaseTopic]()
    func registerFCM(_ fcm: String, topics: [FirebaseTopic]) {
        capturedFCM = fcm
        self.topics = topics
    }

    var registeredTestTopic: Bool {
        return topics.contains(.test)
    }

    var registeredLiveTopic: Bool {
        return topics.contains(.live)
    }

    var registeredAnnouncementsTopic: Bool {
        return topics.contains(.announcements)
    }

    var registeredToiOSTopic: Bool {
        return topics.contains(.ios)
    }
    
}
