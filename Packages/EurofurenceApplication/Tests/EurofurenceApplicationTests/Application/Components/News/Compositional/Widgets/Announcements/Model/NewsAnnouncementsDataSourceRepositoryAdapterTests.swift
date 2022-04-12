import Combine
import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class NewsAnnouncementsDataSourceRepositoryAdapterTests: XCTestCase {
    
    func testPropogatesAnnouncements() {
        let announcements = [FakeAnnouncement.random, FakeAnnouncement.random, FakeAnnouncement.random]
        let service = FakeAnnouncementsRepository(announcements: announcements)
        let dataSource = NewsAnnouncementsDataSourceRepositoryAdapter(repository: service)
        
        var observedAnnouncements: [FakeAnnouncement] = []
        let subscription = dataSource
            .announcements
            .sink { (upstreamAnnouncements) in
                observedAnnouncements = (upstreamAnnouncements as? [FakeAnnouncement]) ?? []
            }
        
        defer {
            subscription.cancel()
        }
        
        let announcementsEqual = announcements.elementsEqual(observedAnnouncements, by: { $0 === $1 })
        
        XCTAssertTrue(announcementsEqual, "Expected to receive announcements from repository")
    }
    
}
