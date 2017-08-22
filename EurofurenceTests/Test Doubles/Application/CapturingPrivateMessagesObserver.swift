//
//  CapturingPrivateMessagesObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingPrivateMessagesObserver {
    
    private(set) var wasToldSuccessfullyLoadedPrivateMessages = false
    private(set) var capturedMessages: [Message]?
    private(set) var wasToldFailedToLoadPrivateMessages = false
    private(set) var wasToldUserNotAuthenticated = false
    func completionHandler(_ result: PrivateMessageResult) {
        switch result {
        case .success(let messages):
            self.wasToldSuccessfullyLoadedPrivateMessages = true
            self.capturedMessages = messages
            
        case .userNotAuthenticated:
            self.wasToldUserNotAuthenticated = true
            
        case .failedToLoad:
            self.wasToldFailedToLoadPrivateMessages = true
        }
    }
    
}
