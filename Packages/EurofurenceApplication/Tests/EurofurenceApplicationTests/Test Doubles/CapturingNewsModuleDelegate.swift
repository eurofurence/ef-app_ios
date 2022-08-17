import EurofurenceApplication
import EurofurenceModel
import Foundation
import XCTEurofurenceModel

class CapturingNewsComponentDelegate: NewsComponentDelegate {

    private(set) var showPrivateMessagesRequested = false
    func newsModuleDidRequestShowingPrivateMessages() {
        showPrivateMessagesRequested = true
    }

    private(set) var capturedAnnouncement: AnnouncementIdentifier?
    func newsModuleDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        capturedAnnouncement = announcement
    }

    private(set) var capturedEvent: EventIdentifier?
    func newsModuleDidSelectEvent(_ event: EventIdentifier) {
        capturedEvent = event
    }

    private(set) var showAllAnnouncementsRequested = false
    func newsModuleDidRequestShowingAllAnnouncements() {
        showAllAnnouncementsRequested = true
    }
    
    private(set) var showSettingsSender: Any?
    func newsModuleDidRequestShowingSettings(sender: Any) {
        showSettingsSender = sender
    }

}
