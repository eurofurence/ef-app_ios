//
//  CapturingNewsModuleDelegate.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/10/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation

class CapturingNewsModuleDelegate: NewsModuleDelegate {

    private(set) var showPrivateMessagesRequested = false
    func newsModuleDidRequestShowingPrivateMessages() {
        showPrivateMessagesRequested = true
    }

    private(set) var capturedAnnouncement: AnnouncementIdentifier?
    func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        capturedAnnouncement = announcement
    }

    private(set) var capturedEvent: EventProtocol?
    func newsModuleDidSelectEvent(_ event: EventProtocol) {
        capturedEvent = event
    }

    private(set) var showAllAnnouncementsRequested = false
    func newsModuleDidRequestShowingAllAnnouncements() {
        showAllAnnouncementsRequested = true
    }

}
