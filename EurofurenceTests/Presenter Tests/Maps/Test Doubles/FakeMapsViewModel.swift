//
//  FakeMapsViewModel.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class FakeMapsViewModel: MapsViewModel {

    var numberOfMaps: Int {
        return maps.count
    }

    var maps = [FakeMapViewModel(), FakeMapViewModel(), FakeMapViewModel()]

    func mapViewModel(at index: Int) -> MapViewModel2 {
        return maps[index]
    }

    func identifierForMap(at index: Int) -> Map.Identifier? {
        return Map.Identifier("\(index)")
    }

}

class FakeMapViewModel: MapViewModel2 {

    var mapName: String = .random
    var mapPreviewImagePNGData: Data = .random

    func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void) {
        completionHandler(mapPreviewImagePNGData)
    }

}
