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

    private var models = [Map2]() {
        didSet {
            observers.forEach({ $0.mapsServiceDidChangeMaps(models) })
        }
    }

    private var observers = [MapsObserver]()

    init(eventBus: EventBus) {
        eventBus.subscribe(consumer: RefreshMapsAfterSync(handler: updateModels))
    }

    func add(_ observer: MapsObserver) {
        observers.append(observer)
        observer.mapsServiceDidChangeMaps(models)
    }

    private func updateModels(_ serverModels: [APIMap]) {
        models = serverModels.map({ (map) -> Map2 in
            return Map2(identifier: Map2.Identifier(map.identifier), location: map.mapDescription)
        }).sorted(by: { (first, second) -> Bool in
            return first.location < second.location
        })
    }

}
