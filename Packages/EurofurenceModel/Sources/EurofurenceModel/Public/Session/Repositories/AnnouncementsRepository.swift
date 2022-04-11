import Foundation

public protocol AnnouncementsRepository {
    
    func add(_ observer: AnnouncementsRepositoryObserver)
    func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement?

}

public protocol AnnouncementsRepositoryObserver {

    func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement])
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier])

}
