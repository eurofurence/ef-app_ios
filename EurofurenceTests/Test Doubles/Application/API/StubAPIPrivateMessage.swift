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
    
    var authorName: String = ""
    
}
