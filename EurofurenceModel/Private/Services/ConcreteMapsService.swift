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

    private var serverModels = [MapCharacteristics]()
    private var roomServerModels = [RoomCharacteristics]()
    private var dealerServerModels = [DealerCharacteristics]()

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

    private struct MapEntryDisplacementResult {
        var entry: MapCharacteristics.Entry
        var displacement: Double
    }
    
    func fetchMap(for identifier: MapIdentifier) -> Map? {
        return models.first(where: { $0.identifier == identifier })
    }

    func fetchContent(for identifier: MapIdentifier,
                      atX x: Int,
                      y: Int,
                      completionHandler: @escaping (MapContent) -> Void) {
        var content: MapContent = .none
        defer { completionHandler(content) }

        guard let model = serverModels.first(where: { $0.identifier == identifier.rawValue }) else { return }

        let tappedWithinEntry: (MapCharacteristics.Entry) -> MapEntryDisplacementResult? = { (entry) -> MapEntryDisplacementResult? in
            let tapRadius = entry.tapRadius
            let horizontalDelta = abs(entry.x - x)
            let verticalDelta = abs(entry.y - y)
            let delta = hypot(Double(horizontalDelta), Double(verticalDelta))

            guard delta < Double(tapRadius) else { return nil }

            return MapEntryDisplacementResult(entry: entry, displacement: delta)
        }

        guard let entry = model.entries.compactMap(tappedWithinEntry).sorted(by: { $0.displacement < $1.displacement }).first?.entry else { return }

        let contentFromLink: (MapCharacteristics.Entry.Link) -> MapContent? = { (link) in
            if let room = self.roomServerModels.first(where: { $0.roomIdentifier == link.target }) {
                return .room(Room(name: room.name))
            }

            if let dealer = self.dealers.fetchDealer(for: DealerIdentifier(link.target)) {
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
        guard let maps = dataStore.fetchMaps(),
              let rooms = dataStore.fetchRooms(),
              let dealers = dataStore.fetchDealers() else {
                return
        }

        serverModels = maps
        roomServerModels = rooms
        dealerServerModels = dealers

        models = serverModels.map(makeMap).sorted(by: { (first, second) -> Bool in
            return first.location < second.location
        })
    }
    
    private func makeMap(from characteristics: MapCharacteristics) -> MapImpl {
        return MapImpl(imageRepository: imageRepository, dataStore: dataStore, characteristics: characteristics, dealers: dealers)
    }

}
