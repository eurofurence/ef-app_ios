import Combine
import EurofurenceApplication
import EurofurenceModel

class ControllableNewsAnnouncementsDataSource: NewsAnnouncementsDataSource {
    
    let announcements = CurrentValueSubject<[Announcement], Never>([])
    
    func updateAnnouncements(_ announcements: [Announcement]) {
        self.announcements.value = announcements
    }
    
}
