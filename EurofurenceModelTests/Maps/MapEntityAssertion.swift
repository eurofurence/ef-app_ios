//
//  MapEntityAssertion.swift
//  EurofurenceModelTests
//
//  Created by Thomas Sherwood on 14/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EurofurenceModel

class MapEntityAssertion: EntityAssertion {

    func assertMaps(_ maps: [MapProtocol], characterisedBy characteristics: [MapCharacteristics]) {
        guard maps.count == characteristics.count else {
            fail(message: "Expected \(characteristics.count) maps, got \(maps.count)")
            return
        }

        let orderedCharacteristics: [MapCharacteristics] = characteristics.sorted(by: { $0.mapDescription < $1.mapDescription })
        for (idx, map) in maps.enumerated() {
            let characteristic = orderedCharacteristics[idx]

            assert(characteristic.identifier, isEqualTo: map.identifier.rawValue)
            assert(characteristic.mapDescription, isEqualTo: map.location)
        }
    }

}
