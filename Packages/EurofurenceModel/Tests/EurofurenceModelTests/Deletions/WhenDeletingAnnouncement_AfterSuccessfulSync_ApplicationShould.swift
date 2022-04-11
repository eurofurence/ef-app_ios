import EurofurenceModel
import XCTest

class WhenDeletingAnnouncement_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testUpdateDelegateWithoutDeletedAnnouncement() {
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        let delegate = CapturingAnnouncementsRepositoryObserver()
        context.announcementsService.add(delegate)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let announcementToDelete = response.announcements.changed.randomElement().element
        let announcements = response.announcements.changed
        response.announcements.changed = announcements.filter({ $0.identifier != announcementToDelete.identifier })
        response.announcements.changed.removeAll()
        response.announcements.deleted.append(announcementToDelete.identifier)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let actual = delegate.allAnnouncements.map(\.identifier.rawValue)
        
        XCTAssertFalse(
            actual.contains(announcementToDelete.identifier),
            "Should have removed announcement \(announcementToDelete.identifier)"
        )
    }

}
