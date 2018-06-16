//
//  SignificantTimeObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 16/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct SignificantTimeObserver: SignificantTimeChangeAdapterDelegate {

    private let significantTimeChangeAdapter: SignificantTimeChangeAdapter
    private let eventBus: EventBus

    init(significantTimeChangeAdapter: SignificantTimeChangeAdapter, eventBus: EventBus) {
        self.significantTimeChangeAdapter = significantTimeChangeAdapter
        self.eventBus = eventBus

        significantTimeChangeAdapter.setDelegate(self)
    }

    func significantTimeChangeDidOccur() {
        eventBus.post(DomainEvent.SignificantTimePassedEvent())
    }

}
