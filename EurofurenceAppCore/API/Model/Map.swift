//
//  Map.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public struct Map: Equatable {

    public struct Identifier: Comparable, Equatable, Hashable, RawRepresentable {

        public typealias RawValue = String

        public init(_ value: String) {
            self.rawValue = value
        }

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }

        public var rawValue: String

        public static func < (lhs: Map.Identifier, rhs: Map.Identifier) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

    }

    public enum Content: Equatable {
        case none
		case location(x: Float, y: Float, name: String?)
        case room(Room)
        case dealer(Dealer)
        indirect case multiple([Map.Content])

        public static func + (lhs: inout Map.Content, rhs: Map.Content) {
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

    public var identifier: Map.Identifier
    public var location: String

    public init(identifier: Map.Identifier, location: String) {
        self.identifier = identifier
        self.location = location
    }

}
