//
//  TrackEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension TrackEntity: EntityAdapting {

    typealias AdaptedType = APITrack

    static func makeIdentifyingPredicate(for model: APITrack) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.trackIdentifier)
    }

    func asAdaptedType() -> APITrack {
        return APITrack(trackIdentifier: identifier!, name: name!)
    }

    func consumeAttributes(from value: APITrack) {
        identifier = value.trackIdentifier
        name = value.name
    }

}
