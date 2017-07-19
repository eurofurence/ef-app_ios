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
    private(set) var capturedAuthenticationToken: String?
    func registerFCM(_ fcm: String, topics: [FirebaseTopic], authenticationToken: String?) {
        capturedFCM = fcm
        self.topics = topics
        capturedAuthenticationToken = authenticationToken
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

    var registeredDebugTopic: Bool {
        return topics.contains(.debug)
    }
    
    func registeredVersionTopic(with version: String) -> Bool {
        return topics.contains(.version(version))
    }
    
}
