@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingAnnouncementViewModel_ForReadAnnouncement_NewsViewModelProducerShould: XCTestCase {

    func testPrepareViewModelWithReadStatus() {
        let announcement = StubAnnouncement.random
        let announcementsService = FakeAnnouncementsService(announcements: [announcement],
                                                            stubbedReadAnnouncements: [announcement.identifier])
        let context = DefaultNewsViewModelProducerTestBuilder().with(announcementsService).build()
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
