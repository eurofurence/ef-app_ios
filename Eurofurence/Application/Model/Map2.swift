//
//  Map2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct Map2: Equatable {

    struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        typealias RawValue = String

        init(_ value: String) {
            self.rawValue = value
        }

        init?(rawValue: String) {
            self.rawValue = rawValue
        }

        var rawValue: String

        static func < (lhs: Map2.Identifier, rhs: Map2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    enum Content: Equatable {
        case location(x: Float, y: Float)
        case room(Room)
    }

    var identifier: Map2.Identifier
    var location: String

}
