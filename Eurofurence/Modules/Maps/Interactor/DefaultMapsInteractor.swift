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
        private let mapsService: MapsService

        init(maps: [Map2], mapsService: MapsService) {
            self.maps = maps
            self.mapsService = mapsService
        }

        var numberOfMaps: Int {
            return maps.count
        }

        func mapViewModel(at index: Int) -> MapViewModel2 {
            let map = maps[index]
            return SingleViewModel(map: map, mapsService: mapsService)
        }

        func identifierForMap(at index: Int) -> Map2.Identifier? {
            return maps[index].identifier
        }

    }

    private struct SingleViewModel: MapViewModel2 {

        private let map: Map2
        private let mapsService: MapsService

        init(map: Map2, mapsService: MapsService) {
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
    private var maps = [Map2]()

    convenience init() {
        self.init(mapsService: EurofurenceApplication.shared)
    }

    init(mapsService: MapsService) {
        self.mapsService = mapsService
        mapsService.add(self)
    }

    func mapsServiceDidChangeMaps(_ maps: [Map2]) {
        self.maps = maps
    }

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(ViewModel(maps: maps, mapsService: mapsService))
    }

}
