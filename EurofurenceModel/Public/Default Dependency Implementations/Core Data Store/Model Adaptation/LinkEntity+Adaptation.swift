//
//  LinkEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension LinkEntity: EntityAdapting {

    typealias AdaptedType = LinkCharacteristics

    static func makeIdentifyingPredicate(for model: LinkCharacteristics) -> NSPredicate {
        return NSPredicate(value: false)
    }

    func asAdaptedType() -> LinkCharacteristics {
        return LinkCharacteristics(name: name!,
                       fragmentType: LinkCharacteristics.FragmentType(rawValue: Int(fragmentType))!,
                       target: target!)
    }

    func consumeAttributes(from value: LinkCharacteristics) {
        name = value.name
        target = value.target
        fragmentType = Int16(Float(value.fragmentType.rawValue))
    }

}
