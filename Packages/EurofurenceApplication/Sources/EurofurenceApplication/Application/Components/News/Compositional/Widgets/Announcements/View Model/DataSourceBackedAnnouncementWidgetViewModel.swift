import EurofurenceModel
import ObservedObject
import RouterCore

public class DataSourceBackedAnnouncementWidgetViewModel: NewsAnnouncementViewModel {
    
    private let announcement: Announcement
    private let router: Router
    
    init(announcement: Announcement, router: Router) {
        self.announcement = announcement
        self.router = router
        
        announcement.add(NotifyViewModelChangedWhenAnnouncementBecomesRead(subject: objectDidChange))
    }
    
    public var title: String {
        announcement.title
    }
    
    public var isUnreadIndicatorVisible: Bool {
        announcement.isRead == false
    }
    
    public func open() {
        try? router.route(AnnouncementRouteable(identifier: announcement.identifier))
    }
    
    private struct NotifyViewModelChangedWhenAnnouncementBecomesRead: AnnouncementObserver {
        
        let subject: DataSourceBackedAnnouncementWidgetViewModel.ObjectDidChangePublisher
        
        func announcementEnteredUnreadState(_ announcement: Announcement) {
            
        }
        
        func announcementEnteredReadState(_ announcement: Announcement) {
            subject.send()
        }
        
    }
    
}
