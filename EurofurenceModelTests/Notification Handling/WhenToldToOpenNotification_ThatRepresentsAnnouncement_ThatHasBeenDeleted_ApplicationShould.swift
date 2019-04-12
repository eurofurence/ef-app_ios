import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsAnnouncement_ThatHasBeenDeleted_ApplicationShould: XCTestCase {

    func testProvideTheInvalidatedAnnouncementResponse() {
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomAnnouncement = syncResponse.announcements.changed.randomElement().element
        let context = EurofurenceSessionTestBuilder().build()
        let payload: [String: String] = ["event": "announcement", "announcement_id": randomAnnouncement.identifier]
        var result: NotificationContent?
        context.notificationsService.handleNotification(payload: payload) { result = $0 }
        syncResponse.announcements.changed = []
        syncResponse.announcements.deleted = [randomAnnouncement.identifier]
        context.api.simulateSuccessfulSync(syncResponse)

        let expected = NotificationContent.invalidatedAnnouncement
        XCTAssertEqual(expected, result)
    }

}
