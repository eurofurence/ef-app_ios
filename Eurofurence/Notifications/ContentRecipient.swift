import EurofurenceModel

protocol ContentRecipient {
    
    func openAnnouncement(_ announcement: AnnouncementIdentifier)
    func openEvent(_ event: EventIdentifier)
    func handleInvalidatedAnnouncement()
    
}
