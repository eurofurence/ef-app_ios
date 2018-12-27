//
//  CapturingPrivateMessagesAPI.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class CapturingPrivateMessagesAPI: PrivateMessagesAPI {

    private(set) var wasToldToLoadPrivateMessages = false
    private(set) var capturedAuthToken: String?
    private var completionHandler: (([Message]?) -> Void)?
    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping ([Message]?) -> Void) {
        wasToldToLoadPrivateMessages = true
        capturedAuthToken = authorizationToken
        self.completionHandler = completionHandler
    }

    private(set) var messageIdentifierMarkedAsRead: String?
    private(set) var capturedAuthTokenForMarkingMessageAsRead: String?
    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        messageIdentifierMarkedAsRead = identifier
        capturedAuthTokenForMarkingMessageAsRead = authorizationToken
    }

    func simulateSuccessfulResponse(response: [Message] = []) {
        completionHandler?(response)
    }

    func simulateUnsuccessfulResponse() {
        completionHandler?(nil)
    }

}
