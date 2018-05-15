//
//  Room.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct Room: Equatable {

    static func ==(lhs: Room, rhs: Room) -> Bool {
        return lhs.name == rhs.name
    }

    var name: String

}
