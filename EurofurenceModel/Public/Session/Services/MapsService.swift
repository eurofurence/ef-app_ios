//
//  MapsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol MapsService {
    
    func add(_ observer: MapsObserver)
    func fetchMap(for identifier: MapIdentifier) -> Map?

}

public protocol MapsObserver {

    func mapsServiceDidChangeMaps(_ maps: [Map])

}
