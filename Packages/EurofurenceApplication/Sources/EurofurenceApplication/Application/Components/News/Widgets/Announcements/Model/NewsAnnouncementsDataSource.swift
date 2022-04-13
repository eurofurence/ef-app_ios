import Combine
import EurofurenceModel

public protocol NewsAnnouncementsDataSource {
    
    associatedtype Announcements: Publisher
        where Announcements.Output == [Announcement], Announcements.Failure == Never
    
    var announcements: Announcements { get }
    
}
