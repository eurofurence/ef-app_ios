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

        let maps: [Map]

        var numberOfMaps: Int {
            return maps.count
        }

        func mapViewModel(at index: Int) -> MapViewModel {
            return SingleViewModel(map: maps[index])
        }

        func identifierForMap(at index: Int) -> MapIdentifier? {
            return maps[index].identifier
        }

    }

    private struct SingleViewModel: MapViewModel {

        let map: Map

        init(map: Map) {
            self.map = map
        }

        var mapName: String {
            return map.location
        }

        func fetchMapPreviewPNGData(completionHandler: @escaping (Data) -> Void) {
            map.fetchImagePNGData(completionHandler: completionHandler)
        }

    }

    private var maps = [Map]()

    convenience init() {
        self.init(mapsService: SharedModel.instance.services.maps)
    }

    init(mapsService: MapsService) {
        mapsService.add(self)
    }

    func mapsServiceDidChangeMaps(_ maps: [Map]) {
        self.maps = maps
    }

    func makeMapsViewModel(completionHandler: @escaping (MapsViewModel) -> Void) {
        completionHandler(ViewModel(maps: maps))
    }

}
