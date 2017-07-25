//
//  StubAPIPrivateMessage.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class StubAPIPrivateMessagesResponse: APIPrivateMessagesResponse {
    
    var messages: [APIPrivateMessage]
    
    init(messages: [APIPrivateMessage] = []) {
        self.messages = messages
    }
    
}

struct StubAPIPrivateMessage: APIPrivateMessage {
    
    var id: String
    var authorName: String
    var subject: String
    var message: String
    var recipientUid: String
    
    init(id: String = "",
         authorName: String = "",
         subject: String = "",
         message: String = "",
         recipientUid: String = "") {
        self.id = id
        self.authorName = authorName
        self.subject = subject
        self.message = message
        self.recipientUid = recipientUid
    }
    
}
