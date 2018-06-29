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

        private let handler: ([APIMap], [APIRoom]) -> Void

        init(handler: @escaping ([APIMap], [APIRoom]) -> Void) {
            self.handler = handler
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            handler(event.response.maps.changed, event.response.rooms.changed)
        }

    }

    private let imageRepository: ImageRepository

    private var serverModels = [APIMap]()
    private var roomServerModels = [APIRoom]()
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
            updateModels(maps, roomServerModels: [])
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

    func fetchContent(for identifier: Map2.Identifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (Map2.Content) -> Void) {
        var content: Map2.Content = .none
        defer { completionHandler(content) }

        guard let model = serverModels.first(where: { $0.identifier == identifier.rawValue }) else { return }

        struct MapEntryDisplacementResult {
            var entry: APIMap.Entry
            var displacement: Double
        }

        let tappedWithinEntry: (APIMap.Entry) -> MapEntryDisplacementResult? = { (entry) -> MapEntryDisplacementResult? in
            let tapRadius = entry.tapRadius
            let horizontalDelta = abs(entry.x - x)
            let verticalDelta = abs(entry.y - y)
            let delta = hypot(Double(horizontalDelta), Double(verticalDelta))

            guard delta < Double(tapRadius) else { return nil }

            return MapEntryDisplacementResult(entry: entry, displacement: delta)
        }

        guard let entry = model.entries.compactMap(tappedWithinEntry).sorted(by: { $0.displacement < $1.displacement }).first?.entry else { return }
        guard let link = entry.links.first else { return }
        guard let room = roomServerModels.first(where: { $0.roomIdentifier == link.target }) else { return }

        content = .room(Room(name: room.name))
    }

    private func updateModels(_ serverModels: [APIMap], roomServerModels: [APIRoom]) {
        self.serverModels = serverModels
        self.roomServerModels = roomServerModels

        models = serverModels.map({ (map) -> Map2 in
            return Map2(identifier: Map2.Identifier(map.identifier), location: map.mapDescription)
        }).sorted(by: { (first, second) -> Bool in
            return first.location < second.location
        })
    }

}
