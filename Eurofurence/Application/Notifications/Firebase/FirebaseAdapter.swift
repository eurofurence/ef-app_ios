//
//  FirebaseAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum FirebaseTopic: String, CustomStringConvertible {
    case test
    case live
    case announcements
    case ios
    case debug

    var description: String {
        return rawValue
    }

}

protocol FirebaseAdapter {

    var fcmToken: String { get }

    func setAPNSToken(deviceToken: Data)
    func subscribe(toTopic topic: FirebaseTopic)
    func unsubscribe(fromTopic topic: FirebaseTopic)

}
