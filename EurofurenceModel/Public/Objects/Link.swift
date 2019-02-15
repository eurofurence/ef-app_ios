//
//  Link.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

public struct Link: Comparable, Hashable, Equatable {

    public enum Kind: Int {
        case webExternal
    }

    public var name: String
    public var type: Kind
    public var contents: AnyHashable

    public init(name: String, type: Kind, contents: AnyHashable) {
        self.name = name
        self.type = type
        self.contents = contents
    }

    public static func <(lhs: Link, rhs: Link) -> Bool {
        return lhs.name < rhs.name
    }

}

extension Link {

    static func fromServerModel(_ link: LinkCharacteristics) -> Link {
        return Link(name: link.name, type: Link.Kind(rawValue: link.fragmentType.rawValue)!, contents: link.target)
    }

    static func fromServerModels(_ links: [LinkCharacteristics]) -> [Link] {
        return links.map(fromServerModel)
    }

}
