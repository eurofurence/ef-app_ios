import Foundation

public typealias AnnouncementIdentifier = Identifier<Announcement>

public protocol Announcement {

    var identifier: AnnouncementIdentifier { get }
    var title: String { get }
    var content: String { get }
    var date: Date { get }
    var isRead: Bool { get }
    
    func add(_ observer: AnnouncementObserver)
    func markRead()
    func fetchAnnouncementImagePNGData(completionHandler: @escaping (Data?) -> Void)

}

public protocol AnnouncementObserver {
    
    func announcementEnteredUnreadState(_ announcement: Announcement)
    func announcementEnteredReadState(_ announcement: Announcement)
    
}
