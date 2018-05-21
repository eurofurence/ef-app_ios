//
//  APITrack.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APITrack: Equatable {

    static func ==(lhs: APITrack, rhs: APITrack) -> Bool {
        return lhs.trackIdentifier == rhs.trackIdentifier &&
               lhs.name == rhs.name
    }

    var trackIdentifier: String
    var name: String

}
