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
    
    private(set) var capturedMessages: [Any]?
    func privateMessagesLoaded(_ privateMessages: [Any]) {
        capturedMessages = privateMessages
    }
    
    private(set) var wasToldFailedToLoadPrivateMessages = false
    func failedToLoadPrivateMessages() {
        wasToldFailedToLoadPrivateMessages = true
    }
    
}
