import EurofurenceModel

struct NavigateToContentNotificationResponseHandler: NotificationResponseHandler {
    
    let director: ApplicationDirector
    
    func handleAnnouncement(_ announcement: AnnouncementIdentifier) {
        director.openAnnouncement(announcement)
    }
    
    func handleEvent(_ event: EventIdentifier) {
        director.openEvent(event)
    }
    
    func handleMessage(_ message: MessageIdentifier) {
        director.openMessage(message)
    }
    
    func handleInvalidatedAnnouncement() {
        director.showInvalidatedAnnouncementAlert()
    }
    
}
