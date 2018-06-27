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
        
        var mapImagePNGData: Data = Data()
        var mapName: String = ""
        
    }
    
    private var maps = [Map2]()
    
    init(mapsService: MapsService) {
        mapsService.add(self)
    }
    
    func makeViewModelForMap(identifier: Map2.Identifier, completionHandler: @escaping (MapDetailViewModel) -> Void) {
        guard let map = maps.first(where: { $0.identifier == identifier }) else { return }
        
        var viewModel = ViewModel()
        viewModel.mapName = map.location
        completionHandler(viewModel)
    }
    
    func mapsServiceDidChangeMaps(_ maps: [Map2]) {
        self.maps = maps
    }
    
}
