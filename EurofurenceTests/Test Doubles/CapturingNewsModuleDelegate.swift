//
//  CapturingNewsModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import Foundation

class CapturingNewsModuleDelegate: NewsModuleDelegate {
    
    private(set) var showPrivateMessagesRequested = false
    func newsModuleDidRequestShowingPrivateMessages() {
        showPrivateMessagesRequested = true
    }
    
    private(set) var capturedAnnouncement: Announcement2.Identifier?
    func newsModuleDidSelectAnnouncement(_ announcement: Announcement2.Identifier) {
        capturedAnnouncement = announcement
    }
    
    private(set) var capturedEvent: Event2?
    func newsModuleDidSelectEvent(_ event: Event2) {
        capturedEvent = event
    }
    
    private(set) var showAllAnnouncementsRequested = false
    func newsModuleDidRequestShowingAllAnnouncements() {
        showAllAnnouncementsRequested = true
    }
    
}
