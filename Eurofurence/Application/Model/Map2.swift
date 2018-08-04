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
        case none
        case location(x: Float, y: Float)
        case room(Room)
        case dealer(Dealer2)
        indirect case multiple([Map2.Content])

        static func + (lhs: inout Map2.Content, rhs: Map2.Content) {
            switch lhs {
            case .multiple(let inner):
                lhs = .multiple(inner + [rhs])

            case .none:
                lhs = rhs

            default:
                lhs = .multiple([lhs, rhs])
            }
        }

    }

    var identifier: Map2.Identifier
    var location: String

}
