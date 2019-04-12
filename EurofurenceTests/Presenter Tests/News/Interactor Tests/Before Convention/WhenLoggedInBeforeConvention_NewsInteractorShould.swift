@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_NewsInteractorShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_DaysUntilConvention_AndAnnouncements() {
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .build()
        context.subscribeViewModelUpdates()

        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
