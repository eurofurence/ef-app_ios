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
    
    func testStoringLoginShouldRetainItBetweenLifetimes() {
        var store = KeychainLoginCredentialStore()
        let credential = LoginCredential(authenticationToken: "Token", tokenExpiryDate: .distantFuture)
        store.store(credential)
        store = KeychainLoginCredentialStore()
        
        XCTAssertEqual(credential, store.persistedCredential)
    }
    
    func testStoringLoginThenDeletingItShouldReturnNilToken() {
        let store = KeychainLoginCredentialStore()
        let credential = LoginCredential(authenticationToken: "Token", tokenExpiryDate: .distantFuture)
        store.store(credential)
        store.deletePersistedToken()
        
        XCTAssertNil(store.persistedCredential)
    }
    
}
