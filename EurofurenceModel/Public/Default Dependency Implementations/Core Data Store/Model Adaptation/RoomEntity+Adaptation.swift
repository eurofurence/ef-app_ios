//
//  RoomEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension RoomEntity: EntityAdapting {

    typealias AdaptedType = APIRoom

    func asAdaptedType() -> APIRoom {
        return APIRoom(roomIdentifier: identifier!, name: name!)
    }

    func consumeAttributes(from value: APIRoom) {
        identifier = value.roomIdentifier
        name = value.name
    }

}
