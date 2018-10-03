//
//  Message.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct Message: Comparable, Equatable {

    var identifier: String
    var authorName: String
    var receivedDateTime: Date
    var subject: String
    var contents: String
    var isRead: Bool

    static func <(lhs: Message, rhs: Message) -> Bool {
        return lhs.receivedDateTime.compare(rhs.receivedDateTime) == .orderedDescending
    }

    static func ==(lhs: Message, rhs: Message) -> Bool {
        return  lhs.identifier == rhs.identifier &&
                lhs.authorName == rhs.authorName &&
                lhs.receivedDateTime == rhs.receivedDateTime &&
                lhs.subject == rhs.subject &&
                lhs.contents == rhs.contents &&
                lhs.isRead == rhs.isRead
    }

}
