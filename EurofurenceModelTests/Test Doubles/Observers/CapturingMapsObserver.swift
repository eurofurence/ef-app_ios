//
//  CapturingMapsObserver.swift
//  EurofurenceAppCoreTests
//
//  Created by Thomas Sherwood on 10/10/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingMapsObserver: MapsObserver {

    private(set) var capturedMaps: [MapProtocol] = []
    func mapsServiceDidChangeMaps(_ maps: [MapProtocol]) {
        capturedMaps = maps
    }

}
