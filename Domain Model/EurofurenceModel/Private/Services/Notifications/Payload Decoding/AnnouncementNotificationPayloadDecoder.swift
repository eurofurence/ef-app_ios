import Foundation

class AnnouncementNotificationPayloadDecoder: NotificationPayloadDecoder {
    
    private let announcementsService: AnnouncementsService
    
    init(nextComponent: NotificationPayloadDecoder?, announcementsService: AnnouncementsService) {
        self.announcementsService = announcementsService
        super.init(nextComponent: nextComponent)
    }
    
    override func process(context: NotificationPayloadDecodingContext) {
        if let announcementIdentifier = context.value(forPayloadKey: "announcement_id") {
            processAnnouncement(announcementIdentifier, context: context)
        } else {
            super.process(context: context)
        }
    }
    
    private func processAnnouncement(_ announcementIdentifier: String, context: NotificationPayloadDecodingContext) {
        let identifier = AnnouncementIdentifier(announcementIdentifier)
        if announcementsService.fetchAnnouncement(identifier: identifier) != nil {
            context.complete(content: .announcement(identifier))
        } else {
            context.complete(content: .invalidatedAnnouncement)
        }
    }
    
}
