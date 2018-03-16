//
//  Link.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct Link: Comparable, Hashable, Equatable {

    var name: String

    var hashValue: Int {
        return name.hashValue
    }

    static func <(lhs: Link, rhs: Link) -> Bool {
        return lhs.name < rhs.name
    }

    static func ==(lhs: Link, rhs: Link) -> Bool {
        return lhs.name == rhs.name
    }

}
