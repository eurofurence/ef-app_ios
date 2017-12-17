//
//  KeychainLoginCredentialStoreTests.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class KeychainLoginCredentialStoreTests: XCTestCase {
    
    private func makeStore() -> KeychainLoginCredentialStore {
        return KeychainLoginCredentialStore(userAccount: "Eurofurence.Test")
    }
    
    func testStoringLoginShouldRetainItBetweenLifetimes() {
        var store = makeStore()
        let credential = LoginCredential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        store.store(credential)
        store = makeStore()
        
        XCTAssertEqual(credential, store.persistedCredential)
    }
    
    func testStoringLoginThenDeletingItShouldReturnNilToken() {
        let store = makeStore()
        let credential = LoginCredential(username: "User",
                                         registrationNumber: 42,
                                         authenticationToken: "Token",
                                         tokenExpiryDate: .distantFuture)
        store.store(credential)
        store.deletePersistedToken()
        
        XCTAssertNil(store.persistedCredential)
    }
    
}
