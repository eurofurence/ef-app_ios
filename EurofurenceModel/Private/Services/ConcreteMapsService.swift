//
//  ConcreteMapsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ConcreteMapsService: MapsService {

    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private let dealers: ConcreteDealersService

    private var models = [MapImpl]() {
        didSet {
            observers.forEach({ $0.mapsServiceDidChangeMaps(models) })
        }
    }

    private var observers = [MapsObserver]()

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageRepository: ImageRepository,
         dealers: ConcreteDealersService) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        self.dealers = dealers
        eventBus.subscribe(consumer: DataStoreChangedConsumer(handler: reloadMapsFromDataStore))

        reloadMapsFromDataStore()
    }

    func add(_ observer: MapsObserver) {
        observers.append(observer)
        observer.mapsServiceDidChangeMaps(models)
    }
    
    func fetchMap(for identifier: MapIdentifier) -> Map? {
        return models.first(where: { $0.identifier == identifier })
    }

    private func reloadMapsFromDataStore() {
        guard let maps = dataStore.fetchMaps() else { return }

        models = maps.map(makeMap).sorted(by: { (first, second) -> Bool in
            return first.location < second.location
        })
    }
    
    private func makeMap(from characteristics: MapCharacteristics) -> MapImpl {
        return MapImpl(imageRepository: imageRepository, dataStore: dataStore, characteristics: characteristics, dealers: dealers)
    }

}
