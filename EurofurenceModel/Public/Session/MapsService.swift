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
    func fetchImagePNGDataForMap(identifier: MapIdentifier, completionHandler: @escaping (Data) -> Void)
    func fetchContent(for identifier: MapIdentifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (Map.Content) -> Void)

}

public protocol MapsObserver {

    func mapsServiceDidChangeMaps(_ maps: [Map])

}
