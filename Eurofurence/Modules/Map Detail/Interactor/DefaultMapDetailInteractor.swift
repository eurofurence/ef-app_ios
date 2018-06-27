//
//  DefaultMapDetailInteractor.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class DefaultMapDetailInteractor: MapDetailInteractor, MapsObserver {

    private struct ViewModel: MapDetailViewModel {

        var identifier: Map2.Identifier
        var mapsService: MapsService
        var mapImagePNGData: Data
        var mapName: String

        func showContentsAtPosition(x: Float, y: Float) {
            mapsService.openContentsForMap(identifier: identifier, atX: x, y: y)
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

    func makeViewModelForMap(identifier: Map2.Identifier, completionHandler: @escaping (MapDetailViewModel) -> Void) {
        guard let map = maps.first(where: { $0.identifier == identifier }) else { return }

        mapsService.fetchImagePNGDataForMap(identifier: identifier) { (mapGraphicData) in
            let viewModel = ViewModel(identifier: identifier,
                                      mapsService: self.mapsService,
                                      mapImagePNGData: mapGraphicData,
                                      mapName: map.location)
            completionHandler(viewModel)
        }
    }

    func mapsServiceDidChangeMaps(_ maps: [Map2]) {
        self.maps = maps
    }

}
