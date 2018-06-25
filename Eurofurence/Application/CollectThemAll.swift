//
//  CollectThemAll.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

class CollectThemAll {

    private class LoggedOut: EventConsumer {

        private let handler: () -> Void

        init(handler: @escaping () -> Void) {
            self.handler = handler
        }

        func consume(event: DomainEvent.LoggedOut) {
            handler()
        }

    }

    private class LoggedIn: EventConsumer {

        private let handler: () -> Void

        init(handler: @escaping () -> Void) {
            self.handler = handler
        }

        func consume(event: DomainEvent.LoggedIn) {
            handler()
        }

    }

    private let collectThemAllRequestFactory: CollectThemAllRequestFactory
    private let credentialStore: CredentialStore

    init(eventBus: EventBus,
         collectThemAllRequestFactory: CollectThemAllRequestFactory,
         credentialStore: CredentialStore) {
        self.collectThemAllRequestFactory = collectThemAllRequestFactory
        self.credentialStore = credentialStore

        eventBus.subscribe(consumer: LoggedOut(handler: notifyObserversGameRequestDidChange))
        eventBus.subscribe(consumer: LoggedIn(handler: notifyObserversGameRequestDidChange))
    }

    private var collectThemAllRequestObservers = [CollectThemAllURLObserver]()
    func subscribe(_ observer: CollectThemAllURLObserver) {
        collectThemAllRequestObservers.append(observer)
        provideLatestRequestToObserver(observer)
    }

    private func notifyObserversGameRequestDidChange() {
        collectThemAllRequestObservers.forEach(provideLatestRequestToObserver)
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
