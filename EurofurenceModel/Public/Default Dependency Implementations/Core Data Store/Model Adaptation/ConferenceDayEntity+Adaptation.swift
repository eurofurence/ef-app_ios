//
//  ConferenceDayEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension ConferenceDayEntity: EntityAdapting {

    typealias AdaptedType = APIConferenceDay

    func asAdaptedType() -> APIConferenceDay {
        return APIConferenceDay(identifier: identifier!, date: date!)
    }

    func consumeAttributes(from value: APIConferenceDay) {
        identifier = value.identifier
        date = value.date
    }

}
