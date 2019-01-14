//
//  LinkCharacteristics.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 13/03/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct LinkCharacteristics: Comparable, Equatable {

    public enum FragmentType: Int {
        case WebExternal
    }

    public var name: String
    public var fragmentType: FragmentType
    public var target: String

    public init(name: String, fragmentType: FragmentType, target: String) {
        self.name = name
        self.fragmentType = fragmentType
        self.target = target
    }

    public static func <(lhs: LinkCharacteristics, rhs: LinkCharacteristics) -> Bool {
        return lhs.name < rhs.name
    }

    public static func ==(lhs: LinkCharacteristics, rhs: LinkCharacteristics) -> Bool {
        return lhs.name == rhs.name && lhs.fragmentType == rhs.fragmentType && lhs.target == rhs.target
    }

}
