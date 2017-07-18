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
        if let data = Locksmith.loadDataForUserAccount(userAccount: "Eurofurence"),
           let authenticationToken = data["authenticationToken"] as? String,
           let tokenExpiryDate = data["tokenExpiryDate"] as? Date {
            return LoginCredential(authenticationToken: authenticationToken, tokenExpiryDate: tokenExpiryDate)
        } else {
            return nil
        }
    }

    func store(_ loginCredential: LoginCredential) {
        let data: [String : Any] = ["authenticationToken": loginCredential.authenticationToken,
                                    "tokenExpiryDate": loginCredential.tokenExpiryDate]
        try? Locksmith.saveData(data: data, forUserAccount: "Eurofurence")
    }

    func deletePersistedToken() {

    }

}
