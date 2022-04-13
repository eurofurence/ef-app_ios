import ObservedObject

public protocol NewsAnnouncementsWidgetViewModel: ObservedObject {
    
    associatedtype Announcement: NewsAnnouncementViewModel
    
    var numberOfElements: Int { get }
    
    func element(at index: Int) -> AnnouncementWidgetContent<Announcement>
    func openAllAnnouncements()
    
}
