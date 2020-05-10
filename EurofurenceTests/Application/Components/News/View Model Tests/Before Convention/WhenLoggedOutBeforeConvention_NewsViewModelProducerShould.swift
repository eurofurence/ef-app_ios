@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedOutBeforeConvention_NewsViewModelProducerShould: XCTestCase {

    var context: DefaultNewsViewModelProducerTestBuilder.Context!

    override func setUp() {
        super.setUp()

        context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(FakeAuthenticationService.loggedOutService())
            .build()
        context.subscribeViewModelUpdates()
    }

    func testProduceViewModelWithLoginPrompt_DaysUntilConvention_AndAnnouncements() {
        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

    func testFetchMessagesModuleValueWhenAskingForModelInFirstSection() {
        context.assert().thatModel().at(indexPath: IndexPath(item: 0, section: 0), is: .messages)
    }

    func testFetchAnnouncementModuleValueWhenAskingForModelInSecondSection() {
        let randomAnnouncement = context.displayedAnnouncements.randomElement()
        let announcementIndexPath = IndexPath(item: randomAnnouncement.index + 1, section: 2)

        context.assert().thatModel().at(indexPath: announcementIndexPath, is: .announcement(randomAnnouncement.element.identifier))
    }

    func testFetchAllAnnouncementsModuleValueWhenAskingForAllAnnouncementsIndex() {
        let allAnnouncementsComponentIndexPath = IndexPath(item: 0, section: 2)
        context.assert().thatModel().at(indexPath: allAnnouncementsComponentIndexPath, is: .allAnnouncements)
    }

}
