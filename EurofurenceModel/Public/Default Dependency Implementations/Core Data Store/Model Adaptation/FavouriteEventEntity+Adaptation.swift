//
//  FavouriteEventEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 11/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension FavouriteEventEntity: EntityAdapting {

    typealias AdaptedType = Event.Identifier

    func asAdaptedType() -> Event.Identifier {
        return Event.Identifier(eventIdentifier!)
    }

}
