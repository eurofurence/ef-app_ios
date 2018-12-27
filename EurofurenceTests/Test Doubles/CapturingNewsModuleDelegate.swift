//
//  CapturingNewsModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import Foundation

class CapturingNewsModuleDelegate: NewsModuleDelegate {

    private(set) var showPrivateMessagesRequested = false
    func newsModuleDidRequestShowingPrivateMessages() {
        showPrivateMessagesRequested = true
    }

    private(set) var capturedAnnouncement: Announcement.Identifier?
    func newsModuleDidSelectAnnouncement(_ announcement: Announcement.Identifier) {
        capturedAnnouncement = announcement
    }

    private(set) var capturedEvent: Event?
    func newsModuleDidSelectEvent(_ event: Event) {
        capturedEvent = event
    }

    private(set) var showAllAnnouncementsRequested = false
    func newsModuleDidRequestShowingAllAnnouncements() {
        showAllAnnouncementsRequested = true
    }

}
