//
//  ConferenceDayEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension ConferenceDayEntity: EntityAdapting {

    typealias AdaptedType = ConferenceDayCharacteristics

    static func makeIdentifyingPredicate(for model: ConferenceDayCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> ConferenceDayCharacteristics {
        return ConferenceDayCharacteristics(identifier: identifier!, date: date!)
    }

    func consumeAttributes(from value: ConferenceDayCharacteristics) {
        identifier = value.identifier
        date = value.date
    }

}
