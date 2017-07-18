//
//  LoginCredentialStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

protocol LoginCredentialStore {

    var persistedCredential: LoginCredential? { get }

    func store(_ loginCredential: LoginCredential)

}
