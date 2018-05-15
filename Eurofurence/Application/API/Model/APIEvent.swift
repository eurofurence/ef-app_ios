//
//  APIEvent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIEvent: Equatable {

    static func ==(lhs: APIEvent, rhs: APIEvent) -> Bool {
        return lhs.roomIdentifier == rhs.roomIdentifier &&
               lhs.startDateTime == rhs.startDateTime &&
               lhs.endDateTime == rhs.endDateTime &&
               lhs.title == rhs.title
    }

    var roomIdentifier: String
    var startDateTime: Date
    var endDateTime: Date
    var title: String

}
