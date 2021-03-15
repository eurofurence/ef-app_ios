import EurofurenceApplication
import EurofurenceModel

class CapturingAnnouncementsComponentDelegate: AnnouncementsComponentDelegate {

    private(set) var capturedSelectedAnnouncement: AnnouncementIdentifier?
    func announcementsComponentDidSelectAnnouncement(_ announcement: AnnouncementIdentifier) {
        capturedSelectedAnnouncement = announcement
    }

}
