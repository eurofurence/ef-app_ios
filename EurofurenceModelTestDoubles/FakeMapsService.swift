//
//  FakeMapsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

public class FakeMapsService: MapsService {
    
    public init() {
        
    }
    
    public let maps = [StubMap].random
    public func add(_ observer: MapsObserver) {
        observer.mapsServiceDidChangeMaps(maps)
    }
    
    public func fetchMap(for identifier: MapIdentifier) -> Map? {
        return maps.first(where: { $0.identifier == identifier })
    }
    
    public func fetchContent(for identifier: MapIdentifier,
                             atX x: Int,
                             y: Int,
                             completionHandler: @escaping (MapContent) -> Void) {
        
    }
    
}
