import EurofurenceModel
import Foundation

public class FakeAnnouncementsRepository: AnnouncementsRepository {

    public var announcements: [Announcement]
    public var stubbedReadAnnouncements: [AnnouncementIdentifier]

    public init(announcements: [Announcement], stubbedReadAnnouncements: [AnnouncementIdentifier] = []) {
        self.announcements = announcements
        self.stubbedReadAnnouncements = stubbedReadAnnouncements
    }

    fileprivate var observers = [AnnouncementsRepositoryObserver]()
    public func add(_ observer: AnnouncementsRepositoryObserver) {
        observers.append(observer)
        observer.announcementsServiceDidChangeAnnouncements(announcements)
        observer.announcementsServiceDidUpdateReadAnnouncements(stubbedReadAnnouncements)
    }

    public func fetchAnnouncement(identifier: AnnouncementIdentifier) -> Announcement? {
        return announcements.first(where: { $0.identifier == identifier })
    }

}

public extension FakeAnnouncementsRepository {

    func updateAnnouncements(_ announcements: [Announcement]) {
        observers.forEach({ $0.announcementsServiceDidChangeAnnouncements(announcements) })
    }

    func updateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        observers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncements) })
    }

}
