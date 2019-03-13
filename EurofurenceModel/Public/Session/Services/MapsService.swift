//
//  MapsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol MapsService {
    
    func fetchMap(for identifier: MapIdentifier) -> Map?

    func add(_ observer: MapsObserver)
    func fetchContent(for identifier: MapIdentifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (MapContent) -> Void)

}

public protocol MapsObserver {

    func mapsServiceDidChangeMaps(_ maps: [Map])

}
