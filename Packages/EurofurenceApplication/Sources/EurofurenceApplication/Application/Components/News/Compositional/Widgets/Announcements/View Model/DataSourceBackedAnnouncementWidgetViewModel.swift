import ComponentBase
import EurofurenceModel
import Foundation
import ObservedObject
import RouterCore

public class DataSourceBackedAnnouncementWidgetViewModel: NewsAnnouncementViewModel {
    
    private let announcement: Announcement
    private let router: Router
    private let markdownRenderer: MarkdownRenderer
    
    init(
        announcement: Announcement,
        dateFormatter: DateFormatterProtocol,
        markdownRenderer: MarkdownRenderer,
        router: Router
    ) {
        self.announcement = announcement
        self.router = router
        self.markdownRenderer = markdownRenderer
        self.formattedTimestamp = dateFormatter.string(from: announcement.date)
        
        announcement.add(NotifyViewModelChangedWhenAnnouncementBecomesRead(subject: objectDidChange))
    }
    
    public let formattedTimestamp: String
    
    public var title: String {
        announcement.title
    }
    
    public lazy var body: NSAttributedString = {
        markdownRenderer.render(announcement.content)
    }()
    
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
