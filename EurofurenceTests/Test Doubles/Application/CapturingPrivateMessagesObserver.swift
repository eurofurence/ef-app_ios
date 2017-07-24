//
//  CapturingPrivateMessagesObserver.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingPrivateMessagesObserver: PrivateMessagesObserver {
    
    private(set) var wasToldSuccessfullyLoadedPrivateMessages = false
    private(set) var capturedMessages: [Any]?
    func privateMessagesAvailable(_ privateMessages: [Any]) {
        wasToldSuccessfullyLoadedPrivateMessages = true
        capturedMessages = privateMessages
    }
    
    private(set) var wasToldFailedToLoadPrivateMessages = false
    func failedToLoadPrivateMessages() {
        wasToldFailedToLoadPrivateMessages = true
    }
    
    private(set) var wasToldUserNotAuthenticated = false
    func userNotAuthenticatedForPrivateMessages() {
        wasToldUserNotAuthenticated = true
    }
    
}
