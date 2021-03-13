import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_ThenDaysUntilConventionChanges_NewsViewModelProducerShould: XCTestCase {

    func testUpdateTheCountdownWidget() throws {
        let countdownService = StubConventionCountdownService()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(countdownService)
            .build()
        context.subscribeViewModelUpdates()
        let daysUntilConvention = Int.random
        countdownService.changeDaysUntilConvention(to: daysUntilConvention)

        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
