//
//  Maps.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class Maps {

    private class RefreshMapsAfterSync: EventConsumer {

        private let handler: ([APIMap]) -> Void

        init(handler: @escaping ([APIMap]) -> Void) {
            self.handler = handler
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            handler(event.response.maps.changed)
        }

    }

    private let imageRepository: ImageRepository

    private var serverModels = [APIMap]()
    private var models = [Map2]() {
        didSet {
            observers.forEach({ $0.mapsServiceDidChangeMaps(models) })
        }
    }

    private var observers = [MapsObserver]()

    init(eventBus: EventBus, dataStore: EurofurenceDataStore, imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: RefreshMapsAfterSync(handler: updateModels))

        if let maps = dataStore.getSavedMaps() {
            updateModels(maps)
        }
    }

    func add(_ observer: MapsObserver) {
        observers.append(observer)
        observer.mapsServiceDidChangeMaps(models)
    }

    func fetchImagePNGDataForMap(identifier: Map2.Identifier, completionHandler: @escaping (Data) -> Void) {
        guard let map = serverModels.first(where: { $0.identifier == identifier.rawValue }) else { return }
        guard let entity = imageRepository.loadImage(identifier: map.imageIdentifier) else { return }

        completionHandler(entity.pngImageData)
    }

    private func updateModels(_ serverModels: [APIMap]) {
        self.serverModels = serverModels

        models = serverModels.map({ (map) -> Map2 in
            return Map2(identifier: Map2.Identifier(map.identifier), location: map.mapDescription)
        }).sorted(by: { (first, second) -> Bool in
            return first.location < second.location
        })
    }

}
