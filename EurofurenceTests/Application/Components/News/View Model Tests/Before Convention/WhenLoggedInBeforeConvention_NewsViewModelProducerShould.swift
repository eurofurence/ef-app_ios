import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_NewsViewModelProducerShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_DaysUntilConvention_AndAnnouncements() throws {
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .build()
        context.subscribeViewModelUpdates()

        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
