import EurofurenceModel

struct NavigateToContentNotificationResponseHandler: NotificationResponseHandler {
    
    let director: ApplicationDirector
    
    func handleAnnouncement(_ announcement: AnnouncementIdentifier) {
        director.openAnnouncement(announcement)
    }
    
    func handleEvent(_ event: EventIdentifier) {
        director.openEvent(event)
    }
    
    func handleInvalidatedAnnouncement() {
        director.showInvalidatedAnnouncementAlert()
    }
    
}
