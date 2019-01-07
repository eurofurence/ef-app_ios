//
//  Map.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public typealias MapIdentifier = Identifier<Map>

public struct Map: Equatable {

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

    public var identifier: MapIdentifier
    public var location: String

    public init(identifier: MapIdentifier, location: String) {
        self.identifier = identifier
        self.location = location
    }

}
