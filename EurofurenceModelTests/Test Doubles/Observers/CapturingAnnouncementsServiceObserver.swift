import EurofurenceModel
import Foundation

class CapturingAnnouncementsServiceObserver: AnnouncementsServiceObserver {

    private(set) var allAnnouncements: [Announcement] = []
    private(set) var didReceieveEmptyAllAnnouncements = false
    func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement]) {
        allAnnouncements = announcements
        didReceieveEmptyAllAnnouncements = didReceieveEmptyAllAnnouncements || announcements.isEmpty
    }

    private(set) var didReceieveEmptyReadAnnouncements = false
    private(set) var readAnnouncementIdentifiers = [AnnouncementIdentifier]()
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        didReceieveEmptyReadAnnouncements = didReceieveEmptyReadAnnouncements || readAnnouncements.isEmpty
        readAnnouncementIdentifiers = readAnnouncements
    }

}
