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
    private(set) var capturedAuthToken: String?
    private var completionHandler: ((APIResponse<APIPrivateMessagesResponse>) -> Void)?
    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping (APIResponse<APIPrivateMessagesResponse>) -> Void) {
        wasToldToLoadPrivateMessages = true
        capturedAuthToken = authorizationToken
        self.completionHandler = completionHandler
    }
    
    func simulateSuccessfulResponse(response: APIPrivateMessagesResponse = StubAPIPrivateMessagesResponse()) {
        completionHandler?(.success(response))
    }
    
    func simulateUnsuccessfulResponse() {
        completionHandler?(.failure)
    }
    
}
