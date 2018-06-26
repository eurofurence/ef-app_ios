//
//  DefaultMapsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultMapsInteractor: MapsInteractor, MapsObserver {

    private struct ViewModel: MapsViewModel {

        private let maps: [Map2]

        init(maps: [Map2]) {
            self.maps = maps
        }

        var numberOfMaps: Int {
            return maps.count
        }

        func mapViewModel(at index: Int) -> MapViewModel2 {
            return MapViewModel2(mapName: "",
                                 mapPreviewImagePNGData: Data())
        }

        func identifierForMap(at index: Int) -> Map2.Identifier? {
            return nil
        }

    }

    private var maps = [Map2]()

    init(mapsService: MapsService) {
        mapsService.add(self)
    }

    func mapsServiceDidChangeMaps(_ maps: [Map2]) {
        self.maps = maps
    }

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(ViewModel(maps: maps))
    }

}
