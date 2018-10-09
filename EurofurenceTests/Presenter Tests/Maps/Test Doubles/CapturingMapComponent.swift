//
//  CapturingMapComponent.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import Foundation

class CapturingMapComponent: MapComponent {
    
    private(set) var boundMapName: String?
    func setMapName(_ mapName: String) {
        boundMapName = mapName
    }
    
    private(set) var boundMapPreviewData: Data?
    func setMapPreviewImagePNGData(_ data: Data) {
        boundMapPreviewData = data
    }
    
}
