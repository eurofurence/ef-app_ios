//
//  KeychainCredentialStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Locksmith

public struct KeychainCredentialStore: CredentialStore {

    private var userAccount: String

    public var persistedCredential: Credential? {
        guard let data = Locksmith.loadDataForUserAccount(userAccount: userAccount) else {
            return nil
        }

        return Credential(keychainData: data)
    }

    public init(userAccount: String = "Eurofurence") {
        self.userAccount = userAccount
    }

    public func store(_ credential: Credential) {
        do {
            try Locksmith.updateData(data: credential.keychainData, forUserAccount: userAccount)
        } catch {
            print("Unable to save credentials to Keychain: \(error)")
        }
    }

    public func deletePersistedToken() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
        } catch {
            print("Unable to delete credential from Keychain: \(error)")
        }
    }

}

fileprivate extension Credential {

    var keychainData: [String: Any] {
        return ["username": username,
                "registrationNumber": registrationNumber,
                "authenticationToken": authenticationToken,
                "tokenExpiryDate": tokenExpiryDate]
    }

    init?(keychainData: [String: Any]) {
        guard let username = keychainData["username"] as? String,
              let registrationNumber = keychainData["registrationNumber"] as? Int,
              let authenticationToken = keychainData["authenticationToken"] as? String,
              let tokenExpiryDate = keychainData["tokenExpiryDate"] as? Date else {
                return nil
        }

        self.username = username
        self.registrationNumber = registrationNumber
        self.authenticationToken = authenticationToken
        self.tokenExpiryDate = tokenExpiryDate
    }

}
