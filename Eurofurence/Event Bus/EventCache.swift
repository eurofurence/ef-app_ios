//
//  EventCache.swift
//  EventBus
//
//  Created by Thomas Sherwood on 25/07/2016.
//  Copyright © 2016 ShezHsky. All rights reserved.
//

final class EventCache {

    // MARK: Properties

    private var storage = [Any]()

    // MARK: Public

    func append(event: Any) {
        if let index = storage.index(where: { type(of: $0) == type(of: event) }) {
            storage.remove(at: index)
        }

        storage.append(event)
    }

    func cachedEvent<Event>(ofType type: Event.Type) -> Event? {
        return storage.compactMap({ $0 as? Event }).first
    }

}
