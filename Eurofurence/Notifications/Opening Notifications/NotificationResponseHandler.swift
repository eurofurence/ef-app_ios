import EurofurenceModel

protocol NotificationResponseHandler {
    
    func handleAnnouncement(_ announcement: AnnouncementIdentifier)
    func handleEvent(_ event: EventIdentifier)
    func handleMessage(_ message: MessageIdentifier)
    func handleInvalidatedAnnouncement()
    
}
