//
//  Maps.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class Maps {

    private let dataStore: DataStore
    private let imageRepository: ImageRepository
    private let dealers: Dealers

    private var serverModels = [APIMap]()
    private var roomServerModels = [APIRoom]()
    private var dealerServerModels = [APIDealer]()

    private var models = [Map]() {
        didSet {
            observers.forEach({ $0.mapsServiceDidChangeMaps(models) })
        }
    }

    private var observers = [MapsObserver]()

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageRepository: ImageRepository,
         dealers: Dealers) {
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

    func fetchImagePNGDataForMap(identifier: MapIdentifier, completionHandler: @escaping (Data) -> Void) {
        serverModels
            .first(where: { $0.identifier == identifier.rawValue })
            .let({ imageRepository.loadImage(identifier: $0.imageIdentifier) })
            .let({ completionHandler($0.pngImageData) })
    }

    func fetchContent(for identifier: MapIdentifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (MapContent) -> Void) {
        var content: MapContent = .none
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

        let contentFromLink: (APIMap.Entry.Link) -> MapContent? = { (link) in
            if let room = self.roomServerModels.first(where: { $0.roomIdentifier == link.target }) {
                return .room(Room(name: room.name))
            }

            if let dealer = self.dealers.dealer(for: link.target) {
                return .dealer(dealer)
            }

			if link.type == .mapEntry, let linkedEntry = model.entries.first(where: { $0.identifier == link.target }), let name = link.name {
				return .location(x: Float(linkedEntry.x), y: Float(linkedEntry.y), name: name)
			}

            return nil
        }

        let links = entry.links
        let contents: [MapContent] = links.compactMap(contentFromLink)
        content = contents.reduce(into: MapContent.none, +)
    }

    private func reloadMapsFromDataStore() {
        guard let maps = dataStore.getSavedMaps(),
              let rooms = dataStore.getSavedRooms(),
              let dealers = dataStore.getSavedDealers() else {
                return
        }

        serverModels = maps
        roomServerModels = rooms
        dealerServerModels = dealers

        models = serverModels.map({ (map) -> Map in
            return Map(identifier: MapIdentifier(map.identifier), location: map.mapDescription)
        }).sorted(by: { (first, second) -> Bool in
            return first.location < second.location
        })
    }

}
