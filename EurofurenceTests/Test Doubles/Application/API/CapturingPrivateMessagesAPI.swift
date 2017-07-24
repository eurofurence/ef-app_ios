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
    private var completionHandler: ((APIResponse<APIPrivateMessagesResponse>) -> Void)?
    func loadPrivateMessages(completionHandler: @escaping (APIResponse<APIPrivateMessagesResponse>) -> Void) {
        wasToldToLoadPrivateMessages = true
        self.completionHandler = completionHandler
    }
    
    func simulateSuccessfulResponse(response: APIPrivateMessagesResponse = StubAPIPrivateMessagesResponse()) {
        completionHandler?(.success(response))
    }
    
    func simulateUnsuccessfulResponse() {
        completionHandler?(.failure)
    }
    
}
