@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingAnnouncementViewModel_ForReadAnnouncement_NewsInteractorShould: XCTestCase {

    func testPrepareViewModelWithReadStatus() {
        let announcement = StubAnnouncement.random
        let announcementsService = FakeAnnouncementsService(announcements: [announcement],
                                                            stubbedReadAnnouncements: [announcement.identifier])
        let context = DefaultNewsInteractorTestBuilder().with(announcementsService).build()
        context.subscribeViewModelUpdates()

        context
            .assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
