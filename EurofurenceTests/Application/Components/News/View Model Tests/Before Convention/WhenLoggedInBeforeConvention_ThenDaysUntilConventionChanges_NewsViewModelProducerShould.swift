import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_ThenDaysUntilConventionChanges_NewsViewModelProducerShould: XCTestCase {

    func testUpdateTheCountdownWidget() {
        let countdownService = StubConventionCountdownService()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(countdownService)
            .build()
        context.subscribeViewModelUpdates()
        let daysUntilConvention = Int.random
        countdownService.changeDaysUntilConvention(to: daysUntilConvention)

        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
