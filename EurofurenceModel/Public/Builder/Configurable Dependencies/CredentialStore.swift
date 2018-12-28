//
//  CredentialStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

public protocol CredentialStore {

    var persistedCredential: Credential? { get }

    func store(_ credential: Credential)
    func deletePersistedToken()

}
