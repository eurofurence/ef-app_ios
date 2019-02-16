//
//  DefaultMapsInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class DefaultMapsInteractor: MapsInteractor, MapsObserver {

    private struct ViewModel: MapsViewModel {

        private let maps: [Map]
        private let mapsService: MapsService

        init(maps: [Map], mapsService: MapsService) {
            self.maps = maps
            self.mapsService = mapsService
        }

        var numberOfMaps: Int {
            return maps.count
        }

        func mapViewModel(at index: Int) -> MapViewModel {
            let map = maps[index]
            return SingleViewModel(map: map, mapsService: mapsService)
        }

        func identifierForMap(at index: Int) -> MapIdentifier? {
            return maps[index].identifier
        }

    }

    private struct SingleViewModel: MapViewModel {

        private let map: Map
        private let mapsService: MapsService

        init(map: Map, mapsService: MapsService) {
            self.map = map
            self.mapsService = mapsService
        }

        var mapName: String {
            return map.location
        }

        func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void) {
            mapsService.fetchImagePNGDataForMap(identifier: map.identifier, completionHandler: completionHandler)
        }

    }

    private let mapsService: MapsService
    private var maps = [Map]()

    convenience init() {
        self.init(mapsService: SharedModel.instance.services.maps)
    }

    init(mapsService: MapsService) {
        self.mapsService = mapsService
        mapsService.add(self)
    }

    func mapsServiceDidChangeMaps(_ maps: [Map]) {
        self.maps = maps
    }

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(ViewModel(maps: maps, mapsService: mapsService))
    }

}
