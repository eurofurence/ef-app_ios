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
