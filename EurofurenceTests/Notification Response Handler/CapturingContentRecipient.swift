@testable import Eurofurence
import EurofurenceModel

class CapturingContentRecipient: ContentRecipient {
    
    private(set) var openedAnnouncement: AnnouncementIdentifier?
    func openAnnouncement(_ announcement: AnnouncementIdentifier) {
        openedAnnouncement = announcement
    }
    
    private(set) var openedEvent: EventIdentifier?
    func openEvent(_ event: EventIdentifier) {
        openedEvent = event
    }
    
    private(set) var handledInvalidatedAnnouncement = false
    func handleInvalidatedAnnouncement() {
        handledInvalidatedAnnouncement = true
    }
    
}
