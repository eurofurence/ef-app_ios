//
//  ImageModelEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension ImageModelEntity: EntityAdapting {

    typealias AdaptedType = ImageCharacteristics

    static func makeIdentifyingPredicate(for model: ImageCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> ImageCharacteristics {
        return ImageCharacteristics(identifier: identifier!,
                        internalReference: internalReference!)
    }

    func consumeAttributes(from value: ImageCharacteristics) {
        identifier = value.identifier
        internalReference = value.internalReference
    }

}
