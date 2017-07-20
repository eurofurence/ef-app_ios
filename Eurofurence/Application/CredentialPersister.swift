//
//  CredentialPersister.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol CredentialPersisterDelegate {

    func credentialPersister(_ credentialPersister: CredentialPersister, didRetrieve loginCredential: LoginCredential)

}

struct CredentialPersister {

    private let clock: Clock
    private let loginCredentialStore: LoginCredentialStore

    init(clock: Clock, loginCredentialStore: LoginCredentialStore) {
        self.clock = clock
        self.loginCredentialStore = loginCredentialStore
    }

    func loadCredential(delegate: CredentialPersisterDelegate) {
        if let credential = loginCredentialStore.persistedCredential, isCredentialValid(credential) {
            delegate.credentialPersister(self, didRetrieve: credential)
        }
    }

    func persist(_ credential: LoginCredential) {
        loginCredentialStore.store(credential)
    }

    private func isCredentialValid(_ credential: LoginCredential) -> Bool {
        return clock.currentDate.compare(credential.tokenExpiryDate) == .orderedAscending
    }

}
