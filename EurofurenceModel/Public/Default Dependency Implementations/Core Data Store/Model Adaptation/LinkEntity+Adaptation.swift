//
//  LinkEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension LinkEntity: EntityAdapting {

    typealias AdaptedType = APILink

    static func makeIdentifyingPredicate(for model: APILink) -> NSPredicate {
        return NSPredicate(value: false)
    }

    func asAdaptedType() -> APILink {
        return APILink(name: name!,
                       fragmentType: APILink.FragmentType(rawValue: Int(fragmentType))!,
                       target: target!)
    }

    func consumeAttributes(from value: APILink) {
        name = value.name
        target = value.target
        fragmentType = Int16(Float(value.fragmentType.rawValue))
    }

}
