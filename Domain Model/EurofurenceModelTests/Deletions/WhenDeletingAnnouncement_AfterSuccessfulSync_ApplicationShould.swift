import EurofurenceModel
import XCTest

class WhenDeletingAnnouncement_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testUpdateDelegateWithoutDeletedAnnouncement() {
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        let delegate = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(delegate)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let announcementToDelete = response.announcements.changed.randomElement()
        response.announcements.changed = response.announcements.changed.filter({ $0.identifier != announcementToDelete.element.identifier })
        response.announcements.changed.removeAll()
        response.announcements.deleted.append(announcementToDelete.element.identifier)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let actual = delegate.allAnnouncements.map(\.identifier.rawValue)

        XCTAssertFalse(actual.contains(announcementToDelete.element.identifier),
                       "Should have removed announcement \(announcementToDelete.element.identifier)")
    }

}
