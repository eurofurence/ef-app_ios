//
//  ImageModelEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 29/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension ImageModelEntity: EntityAdapting {

    typealias AdaptedType = APIImage

    func asAdaptedType() -> APIImage {
        return APIImage(identifier: identifier!,
                        internalReference: internalReference!)
    }

    func consumeAttributes(from value: APIImage) {
        identifier = value.identifier
        internalReference = value.internalReference
    }

}
