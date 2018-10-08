//
//  Map2.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct Map2: Equatable {

    public struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        public typealias RawValue = String

        public init(_ value: String) {
            self.rawValue = value
        }

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String

        public static func < (lhs: Map2.Identifier, rhs: Map2.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public enum Content: Equatable {
        case none
		case location(x: Float, y: Float, name: String?)
        case room(Room)
        case dealer(Dealer2)
        indirect case multiple([Map2.Content])

        public static func + (lhs: inout Map2.Content, rhs: Map2.Content) {
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

    public var identifier: Map2.Identifier
    public var location: String

    public init(identifier: Map2.Identifier, location: String) {
        self.identifier = identifier
        self.location = location
    }

}
