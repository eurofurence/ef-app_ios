import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenPreparingAnnouncementViewModel_ForReadAnnouncement_NewsViewModelProducerShould: XCTestCase {

    func testPrepareViewModelWithReadStatus() throws {
        let announcement = StubAnnouncement.random
        let announcementsService = FakeAnnouncementsRepository(announcements: [announcement],
                                                            stubbedReadAnnouncements: [announcement.identifier])
        let context = DefaultNewsViewModelProducerTestBuilder().with(announcementsService).build()
        context.subscribeViewModelUpdates()

        try context
            .assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
