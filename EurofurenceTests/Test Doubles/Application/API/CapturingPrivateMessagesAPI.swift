//
//  CapturingPrivateMessagesAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingPrivateMessagesAPI: PrivateMessagesAPI {
    
    private(set) var wasToldToLoadPrivateMessages = false
    private var completionHandler: ((APIResponse<Any>) -> Void)?
    func loadPrivateMessages(completionHandler: @escaping (APIResponse<Any>) -> Void) {
        wasToldToLoadPrivateMessages = true
        self.completionHandler = completionHandler
    }
    
    func simulateSuccessfulResponse() {
        completionHandler?(.success([Any]()))
    }
    
    func simulateUnsuccessfulResponse() {
        completionHandler?(.failure)
    }
    
}
