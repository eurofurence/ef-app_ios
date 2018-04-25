//
//  CapturingNewsModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import Foundation

class CapturingNewsModuleDelegate: NewsModuleDelegate {
    
    private(set) var loginRequested = false
    func newsModuleDidRequestLogin() {
        loginRequested = true
    }
    
    private(set) var showPrivateMessagesRequested = false
    func newsModuleDidRequestShowingPrivateMessages() {
        showPrivateMessagesRequested = true
    }
    
    private(set) var capturedAnnouncement: Announcement2?
    func newsModuleDidSelectAnnouncement(_ announcement: Announcement2) {
        capturedAnnouncement = announcement
    }
    
}
