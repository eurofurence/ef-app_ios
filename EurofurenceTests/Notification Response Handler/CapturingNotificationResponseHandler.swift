@testable import Eurofurence
import EurofurenceModel

class CapturingNotificationResponseHandler: NotificationResponseHandler {
    
    private(set) var handledAnnouncement: AnnouncementIdentifier?
    func handleAnnouncement(_ announcement: AnnouncementIdentifier) {
        handledAnnouncement = announcement
    }
    
    private(set) var handledEvent: EventIdentifier?
    func handleEvent(_ event: EventIdentifier) {
        handledEvent = event
    }
    
    private(set) var handledMessage: MessageIdentifier?
    func handleMessage(_ message: MessageIdentifier) {
        handledMessage = message
    }
    
    private(set) var handledInvalidatedAnnouncement = false
    func handleInvalidatedAnnouncement() {
        handledInvalidatedAnnouncement = true
    }
    
}
