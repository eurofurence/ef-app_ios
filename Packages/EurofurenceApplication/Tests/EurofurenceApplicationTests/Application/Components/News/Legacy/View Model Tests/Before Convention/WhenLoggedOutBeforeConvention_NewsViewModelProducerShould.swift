import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenLoggedOutBeforeConvention_NewsViewModelProducerShould: XCTestCase {

    var context: DefaultNewsViewModelProducerTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAnnouncementsRepository(announcements: [FakeAnnouncement].random))
            .with(FakeAuthenticationService.loggedOutService())
            .build()
        context.subscribeViewModelUpdates()
    }

    func testProduceViewModelWithLoginPrompt_DaysUntilConvention_AndAnnouncements() throws {
        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

    func testFetchMessagesModuleValueWhenAskingForModelInFirstSection() throws {
        try context.assert().thatModel().at(indexPath: IndexPath(item: 0, section: 0), is: .messages)
    }

    func testFetchAnnouncementModuleValueWhenAskingForModelInSecondSection() throws {
        let randomAnnouncement = context.displayedAnnouncements.randomElement()
        let announcementIndexPath = IndexPath(item: randomAnnouncement.index + 1, section: 2)

        try context
            .assert()
            .thatModel()
            .at(indexPath: announcementIndexPath, is: .announcement(randomAnnouncement.element.identifier))
    }

    func testFetchAllAnnouncementsModuleValueWhenAskingForAllAnnouncementsIndex() throws {
        let allAnnouncementsComponentIndexPath = IndexPath(item: 0, section: 2)
        try context.assert().thatModel().at(indexPath: allAnnouncementsComponentIndexPath, is: .allAnnouncements)
    }

}
