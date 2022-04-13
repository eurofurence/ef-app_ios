import Combine
import ObservedObject
import RouterCore

public class DataSourceBackedNewsAnnouncementsWidgetViewModel: NewsAnnouncementsWidgetViewModel {
    
    private var subscriptions = Set<AnyCancellable>()
    @Observed private var visibleElements = [AnnouncementWidgetContent<Announcement>]()
    private let router: Router
    
    init<DataSource>(
        dataSource: DataSource,
        configuration: NewsAnnouncementsConfiguration,
        formatters: AnnouncementsWidgetFormatters,
        router: Router
    ) where DataSource: NewsAnnouncementsDataSource {
        self.router = router
        
        dataSource
            .announcements
            .map { (announcements) in
                let visibleAnnouncements = announcements.prefix(configuration.maxDisplayedAnnouncements)
                let announcementViewModels = visibleAnnouncements.map({ (announcement) in
                    DataSourceBackedAnnouncementWidgetViewModel(
                        announcement: announcement,
                        dateFormatter: formatters.announcementTimestamps,
                        markdownRenderer: formatters.markdownRenderer,
                        router: router
                    )
                })
                
                var visibleElements = [AnnouncementWidgetContent<Announcement>]()
                if visibleAnnouncements.count != announcements.count {
                    visibleElements.append(.showMoreAnnouncements)
                }
                
                let announcementElements = announcementViewModels.map({ AnnouncementWidgetContent.announcement($0) })
                visibleElements.append(contentsOf: announcementElements)
                
                return visibleElements
            }
            .sink { [weak self] (visibleElements) in
                self?.visibleElements = visibleElements
            }
            .store(in: &subscriptions)
    }
    
    public typealias Announcement = DataSourceBackedAnnouncementWidgetViewModel
    
    public var numberOfElements: Int {
        visibleElements.count
    }
    
    public func element(at index: Int) -> AnnouncementWidgetContent<Announcement> {
        visibleElements[index]
    }
    
    public func openAllAnnouncements() {
        try? router.route(AnnouncementsRouteable())
    }
    
}
