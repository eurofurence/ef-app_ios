//
//  FakeMapsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class FakeMapsService: MapsService {
    
    let maps = [Map2].random
    func add(_ observer: MapsObserver) {
        observer.mapsServiceDidChangeMaps(maps)
    }
    
}
