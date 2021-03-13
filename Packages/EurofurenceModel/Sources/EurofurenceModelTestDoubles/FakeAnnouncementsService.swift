import EurofurenceModel
import Foundation

public class FakeAnnouncementsService: AnnouncementsService {

    public var announcements: [Announcement]
    public var stubbedReadAnnouncements: [AnnouncementIdentifier]

    public init(announcements: [Announcement], stubbedReadAnnouncements: [AnnouncementIdentifier] = []) {
        self.announcements = announcements
        self.stubbedReadAnnouncements = stubbedReadAnnouncements
    }

    fileprivate var observers = [AnnouncementsServiceObserver]()
    public func add(_ observer: AnnouncementsServiceObserver) {
        observers.append(observer)
        observer.announcementsServiceDidChangeAnnouncements(announcements)
        observer.announcementsServiceDidUpdateReadAnnouncements(stubbedReadAnnouncements)
    }

    public func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement? {
        return announcements.first(where: { $0.identifier == identifier })
    }

}

public extension FakeAnnouncementsService {

    func updateAnnouncements(_ announcements: [Announcement]) {
        observers.forEach({ $0.announcementsServiceDidChangeAnnouncements(announcements) })
    }

    func updateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        observers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncements) })
    }

}
