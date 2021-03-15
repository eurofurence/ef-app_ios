import Foundation

public protocol AnnouncementsService {
    
    func add(_ observer: AnnouncementsServiceObserver)
    func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement?

}

public protocol AnnouncementsServiceObserver {

    func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement])
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier])

}
