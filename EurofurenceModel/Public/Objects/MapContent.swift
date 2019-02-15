//
//  MapContent.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/01/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import Foundation

public enum MapContent: Equatable {
    case none
    case location(x: Float, y: Float, name: String?)
    case room(Room)
    case dealer(Dealer)
    indirect case multiple([MapContent])

    public static func == (lhs: MapContent, rhs: MapContent) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true

        case (.location(let lx, let ly, let lname), .location(let rx, let ry, let rname)):
            return lx == rx && ly == ry && lname == rname

        case (.room(let lRoom), .room(let rRoom)):
            return lRoom == rRoom

        case (.dealer(let lDealer), .dealer(let rDealer)):
            return lDealer.identifier == rDealer.identifier

        case (.multiple(let lMultiple), .multiple(let rMultiple)):
            return lMultiple.elementsEqual(rMultiple)

        default:
            return false
        }
    }

    public static func + (lhs: inout MapContent, rhs: MapContent) {
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
