//
//  MapEntity+Adaptation.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

extension MapEntity: EntityAdapting {

    typealias AdaptedType = APIMap

    func asAdaptedType() -> APIMap {
        return APIMap(identifier: identifier!,
                      imageIdentifier: imageIdentifier!,
                      mapDescription: mapDescription!)
    }

}
