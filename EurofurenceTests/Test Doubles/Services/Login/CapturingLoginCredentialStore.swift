//
//  CapturingLoginCredentialStore.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 18/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingLoginCredentialStore: LoginCredentialStore {
    
    init(persistedCredential: LoginCredential? = nil) {
        self.persistedCredential = persistedCredential
    }
    
    private(set) var persistedCredential: LoginCredential?
    
    private(set) var capturedCredential: LoginCredential?
    func store(_ loginCredential: LoginCredential) {
        capturedCredential = loginCredential
    }
    
}
