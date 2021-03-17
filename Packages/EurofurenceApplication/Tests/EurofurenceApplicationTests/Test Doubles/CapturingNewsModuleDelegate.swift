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

    private(set) var capturedEvent: Event?
    func newsModuleDidSelectEvent(_ event: Event) {
        capturedEvent = event
    }

    private(set) var showAllAnnouncementsRequested = false
    func newsModuleDidRequestShowingAllAnnouncements() {
        showAllAnnouncementsRequested = true
    }

}
