import Combine
import EurofurenceModel

public struct NewsAnnouncementsDataSourceRepositoryAdapter: NewsAnnouncementsDataSource {
    
    public let announcements = CurrentValueSubject<[Announcement], Never>([])
    
    public init(repository: AnnouncementsRepository) {
        repository.add(UpdateStreamWhenRepositoryChanges(upstream: announcements))
    }
    
    private struct UpdateStreamWhenRepositoryChanges: AnnouncementsRepositoryObserver {
        
        let upstream: CurrentValueSubject<[Announcement], Never>
        
        func announcementsServiceDidChangeAnnouncements(_ announcements: [Announcement]) {
            upstream.value = announcements
        }
        
        func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
            
        }
        
    }
    
}
