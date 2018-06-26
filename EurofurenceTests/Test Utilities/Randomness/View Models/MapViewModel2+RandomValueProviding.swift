//
//  MapViewModel2+RandomValueProviding.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

extension MapViewModel2: RandomValueProviding {
    
    static var random: MapViewModel2 {
        return MapViewModel2(mapName: .random, mapPreviewImagePNGData: .random)
    }
    
}
