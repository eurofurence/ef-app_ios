//
//  CredentialPersister.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol CredentialPersisterDelegate {

    func credentialPersister(_ credentialPersister: CredentialPersister, didRetrieve credential: Credential)

}

struct CredentialPersister {

    private let clock: Clock
    private let credentialStore: CredentialStore

    init(clock: Clock, credentialStore: CredentialStore) {
        self.clock = clock
        self.credentialStore = credentialStore
    }

    func loadCredential(delegate: CredentialPersisterDelegate) {
        if let credential = credentialStore.persistedCredential, isCredentialValid(credential) {
            delegate.credentialPersister(self, didRetrieve: credential)
        }
    }

    func persist(_ credential: Credential) {
        credentialStore.store(credential)
    }

    func deleteCredential() {
        credentialStore.deletePersistedToken()
    }

    private func isCredentialValid(_ credential: Credential) -> Bool {
        return clock.currentDate.compare(credential.tokenExpiryDate) == .orderedAscending
    }

}
