//
//  CapturingFCMDeviceRegistration.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class CapturingFCMDeviceRegistration: FCMDeviceRegistration {

    private(set) var capturedFCM: String?
    private var topics = [FirebaseTopic]()
    private(set) var capturedAuthenticationToken: String?
    private(set) var completionHandler: ((Error?) -> Void)?
    func registerFCM(_ fcm: String,
                     topics: [FirebaseTopic],
                     authenticationToken: String?,
                     completionHandler: @escaping (Error?) -> Void) {
        capturedFCM = fcm
        self.topics = topics
        capturedAuthenticationToken = authenticationToken
        self.completionHandler = completionHandler
    }

    var registeredTestTopic: Bool {
        return topics.contains(.test)
    }

    var registeredLiveTopic: Bool {
        return topics.contains(.live)
    }

    var registeredToiOSTopic: Bool {
        return topics.contains(.ios)
    }

    var registeredDebugTopic: Bool {
        return topics.contains(.debug)
    }
    
    var registeredTestiOSTopic: Bool {
        return topics.contains(.testiOS)
    }
    
    var registeredLiveiOSTopic: Bool {
        return topics.contains(.liveiOS)
    }
    
    func registeredVersionTopic(with version: String) -> Bool {
        return topics.contains(.version(version))
    }
    
}
