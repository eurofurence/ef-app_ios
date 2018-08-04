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

        private let maps: Maps

        init(maps: Maps) {
            self.maps = maps
        }

        func consume(event: DomainEvent.LatestDataFetchedEvent) {
            let response = event.response
            maps.updateModels(response.maps, roomServerModels: response.rooms, dealerServerModels: response.dealers)
        }

    }

    private let dataStore: EurofurenceDataStore
    private let imageRepository: ImageRepository
    private let dealers: Dealers

    private var serverModels = [APIMap]()
    private var roomServerModels = [APIRoom]()
    private var dealerServerModels = [APIDealer]()

    private var models = [Map2]() {
        didSet {
            observers.forEach({ $0.mapsServiceDidChangeMaps(models) })
        }
    }

    private var observers = [MapsObserver]()

    init(eventBus: EventBus,
         dataStore: EurofurenceDataStore,
         imageRepository: ImageRepository,
         dealers: Dealers) {
        self.dataStore = dataStore
        self.imageRepository = imageRepository
        self.dealers = dealers
        eventBus.subscribe(consumer: RefreshMapsAfterSync(maps: self))

        reloadMapsFromDataStore()
    }

    func add(_ observer: MapsObserver) {
        observers.append(observer)
        observer.mapsServiceDidChangeMaps(models)
    }

    func fetchImagePNGDataForMap(identifier: Map2.Identifier, completionHandler: @escaping (Data) -> Void) {
        serverModels
            .first(where: { $0.identifier == identifier.rawValue })
            .let({ imageRepository.loadImage(identifier: $0.imageIdentifier) })
            .let({ completionHandler($0.pngImageData) })
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

        let contentFromLink: (APIMap.Entry.Link) -> Map2.Content? = { (link) in
            if let room = self.roomServerModels.first(where: { $0.roomIdentifier == link.target }) {
                return .room(Room(name: room.name))
            }

            if let dealer = self.dealers.dealer(for: link.target) {
                return .dealer(dealer)
            }

            return nil
        }

        let links = entry.links
        content = links.compactMap(contentFromLink).reduce(into: Map2.Content.none, +)
    }

    private func updateModels(_ serverModels: APISyncDelta<APIMap>,
                              roomServerModels: APISyncDelta<APIRoom>,
                              dealerServerModels: APISyncDelta<APIDealer>) {
        dataStore.performTransaction { (transaction) in
            serverModels.deleted.forEach(transaction.deleteMap)
            transaction.saveMaps(serverModels.changed)
        }

        reloadMapsFromDataStore()
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

        models = serverModels.map({ (map) -> Map2 in
            return Map2(identifier: Map2.Identifier(map.identifier), location: map.mapDescription)
        }).sorted(by: { (first, second) -> Bool in
            return first.location < second.location
        })
    }

}
