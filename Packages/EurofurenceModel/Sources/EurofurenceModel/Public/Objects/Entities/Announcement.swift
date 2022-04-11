import Foundation

public typealias AnnouncementIdentifier = Identifier<Announcement>

public protocol Announcement {

    var identifier: AnnouncementIdentifier { get }
    var title: String { get }
    var content: String { get }
    var date: Date { get }
    
    func markRead()
    func fetchAnnouncementImagePNGData(completionHandler: @escaping (Data?) -> Void)

}
