//
//  KeychainLoginCredentialStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Locksmith

struct KeychainLoginCredentialStore: LoginCredentialStore {

    var persistedCredential: LoginCredential? {
        guard let data = Locksmith.loadDataForUserAccount(userAccount: "Eurofurence") else {
            return nil
        }

        return LoginCredential(keychainData: data)
    }

    func store(_ loginCredential: LoginCredential) {
        do {
            try Locksmith.saveData(data: loginCredential.keychainData, forUserAccount: "Eurofurence")
        } catch {
            print("Unable to save credentials to Keychain: \(error)")
        }
    }

    func deletePersistedToken() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "Eurofurence")
        } catch {
            print("Unable to delete credential from Keychain: \(error)")
        }
    }

}

fileprivate extension LoginCredential {

    var keychainData: [String : Any] {
        return ["username": username,
                "registrationNumber": registrationNumber,
                "authenticationToken": authenticationToken,
                "tokenExpiryDate": tokenExpiryDate]
    }

    init?(keychainData: [String : Any]) {
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
