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
    func fetchImagePNGDataForMap(identifier: Map2.Identifier, completionHandler: @escaping (Data) -> Void)
    func fetchContent(for identifier: Map2.Identifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (Map2.Content) -> Void)

}

protocol MapsObserver {

    func mapsServiceDidChangeMaps(_ maps: [Map2])

}
