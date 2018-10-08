//
//  KeychainCredentialStoreTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class KeychainCredentialStoreTests: XCTestCase {
    
    private func makeStore() -> KeychainCredentialStore {
        return KeychainCredentialStore(userAccount: "Eurofurence.Test")
    }
    
    func testStoringLoginShouldRetainItBetweenLifetimes() {
        var store = makeStore()
        let credential = Credential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        store.store(credential)
        store = makeStore()
        
        XCTAssertEqual(credential, store.persistedCredential)
    }
    
    func testStoringLoginThenDeletingItShouldReturnNilToken() {
        let store = makeStore()
        let credential = Credential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        store.store(credential)
        store.deletePersistedToken()
        
        XCTAssertNil(store.persistedCredential)
    }
    
}
