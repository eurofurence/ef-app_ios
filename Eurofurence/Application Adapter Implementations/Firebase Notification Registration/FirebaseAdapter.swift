//
//  FirebaseAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

public enum FirebaseTopic: CustomStringConvertible, Hashable {

    case test
    case testAll
    case testiOS
    case live
    case liveAll
    case liveiOS
    case ios
    case debug
    case version(String)

    public static func ==(lhs: FirebaseTopic, rhs: FirebaseTopic) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    public var hashValue: Int {
        return description.hashValue
    }

    public var description: String {
        switch self {
        case .test:
            return "test"
        case .testAll:
            return "test-all"
        case .testiOS:
            return "test-ios"
        case .live:
            return "live"
        case .liveAll:
            return "live-all"
        case .liveiOS:
            return "live-ios"
        case .ios:
            return "ios"
        case .debug:
            return "debug"
        case .version(let version):
            return "Version-\(version)"
        }
    }

}

public protocol FirebaseAdapter {

    var fcmToken: String { get }

    func setAPNSToken(deviceToken: Data?)
    func subscribe(toTopic topic: FirebaseTopic)
    func unsubscribe(fromTopic topic: FirebaseTopic)

}
