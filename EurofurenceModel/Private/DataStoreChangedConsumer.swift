//
//  DataStoreChangedConsumer.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 05/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class DataStoreChangedConsumer: EventConsumer {

    // MARK: Properties

    private let handler: () -> Void

    // MARK: Initializer

    init(handler: @escaping () -> Void) {
        self.handler = handler
    }

    // MARK: EventConsumer

    typealias Event = DomainEvent.DataStoreChangedEvent

    func consume(event: DomainEvent.DataStoreChangedEvent) {
        handler()
    }

}
