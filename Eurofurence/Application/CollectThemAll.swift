//
//  CollectThemAll.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class CollectThemAll: EventConsumer {

    private let collectThemAllRequestFactory: CollectThemAllRequestFactory
    private let credentialStore: CredentialStore

    init(eventBus: EventBus,
         collectThemAllRequestFactory: CollectThemAllRequestFactory,
         credentialStore: CredentialStore) {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        self.credentialStore = credentialStore

        eventBus.subscribe(consumer: self)
    }

    func consume(event: DomainEvent.LoggedOut) {
        collectThemAllRequestObservers.forEach(provideLatestRequestToObserver)
    }

    private var collectThemAllRequestObservers = [CollectThemAllURLObserver]()
    func subscribe(_ observer: CollectThemAllURLObserver) {
        collectThemAllRequestObservers.append(observer)
        provideLatestRequestToObserver(observer)
    }

    private func provideLatestRequestToObserver(_ observer: CollectThemAllURLObserver) {
        var request: URLRequest
        if let credential = credentialStore.persistedCredential {
            request = collectThemAllRequestFactory.makeAuthenticatedGameURLRequest(credential: credential)

        } else {
            request = collectThemAllRequestFactory.makeAnonymousGameURLRequest()
        }

        observer.collectThemAllGameRequestDidChange(request)
    }

}
