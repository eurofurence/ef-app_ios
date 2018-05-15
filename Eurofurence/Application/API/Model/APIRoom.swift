//
//  APIRoom.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct APIRoom: Equatable {

    static func ==(lhs: APIRoom, rhs: APIRoom) -> Bool {
        return lhs.roomIdentifier == rhs.roomIdentifier && lhs.name == rhs.name
    }

    var roomIdentifier: String
    var name: String

}
