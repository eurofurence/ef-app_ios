//
//  Link.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct Link: Comparable, Hashable, Equatable {

    enum Kind: Int {
        case webExternal
    }

    var name: String
    var type: Kind
    var contents: AnyHashable

    var hashValue: Int {
        return name.hashValue
    }

    static func <(lhs: Link, rhs: Link) -> Bool {
        return lhs.name < rhs.name
    }

    static func ==(lhs: Link, rhs: Link) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.contents == rhs.contents
    }

}

extension Link {

    static func fromServerModel(_ link: APILink) -> Link {
        return Link(name: link.name, type: Link.Kind(rawValue: link.fragmentType.rawValue)!, contents: link.target)
    }

}
