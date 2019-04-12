import EurofurenceModel
import XCTest

class WhenToldToOpenNotification_ThatRepresentsAnnouncement_ApplicationShould: XCTestCase {

    func testProvideTheAnnouncementToTheCompletionHandler() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomAnnouncement = syncResponse.announcements.changed.randomElement().element
        let context = EurofurenceSessionTestBuilder().build()
        let payload: [String: String] = ["event": "announcement", "announcement_id": randomAnnouncement.identifier]
        var result: NotificationContent?
        context.session.services.notifications.handleNotification(payload: payload) { result = $0 }
        context.api.simulateSuccessfulSync(syncResponse)

        let expected = NotificationContent.announcement(AnnouncementIdentifier(randomAnnouncement.identifier))
        XCTAssertEqual(expected, result)
    }

}
