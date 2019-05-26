import EurofurenceModel

protocol NotificationResponseHandler {
    
    func handleAnnouncement(_ announcement: AnnouncementIdentifier)
    func handleEvent(_ event: EventIdentifier)
    func handleInvalidatedAnnouncement()
    
}
