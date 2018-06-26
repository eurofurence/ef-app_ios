//
//  MapsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol MapsService {

    func add(_ observer: MapsObserver)

}

protocol MapsObserver {

    func mapsServiceDidChangeMaps(_ maps: [Map2])

}
