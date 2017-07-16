//
//  FirebaseAdapter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

enum FirebaseTopic: CustomStringConvertible {
    
    case test
    case live
    case announcements
    case ios
    case debug

    private static let descriptions: [FirebaseTopic : String] = [
        .test: "test",
        .live: "live",
        .announcements: "announcements",
        .ios: "ios",
        .debug: "debug"
    ]

    var description: String {
        return FirebaseTopic.descriptions[self] ?? ""
    }

}

protocol FirebaseAdapter {

    var fcmToken: String { get }

    func setAPNSToken(deviceToken: Data)
    func subscribe(toTopic topic: FirebaseTopic)
    func unsubscribe(fromTopic topic: FirebaseTopic)

}
