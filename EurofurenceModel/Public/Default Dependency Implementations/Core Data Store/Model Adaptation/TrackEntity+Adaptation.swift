//
//  TrackEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension TrackEntity: EntityAdapting {

    typealias AdaptedType = TrackCharacteristics

    static func makeIdentifyingPredicate(for model: TrackCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.trackIdentifier)
    }

    func asAdaptedType() -> TrackCharacteristics {
        return TrackCharacteristics(trackIdentifier: identifier!, name: name!)
    }

    func consumeAttributes(from value: TrackCharacteristics) {
        identifier = value.trackIdentifier
        name = value.name
    }

}
