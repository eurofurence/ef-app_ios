@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenLoggedInBeforeConvention_ThenDaysUntilConventionChanges_NewsInteractorShould: XCTestCase {

    func testUpdateTheCountdownWidget() {
        let countdownService = StubConventionCountdownService()
        let context = DefaultNewsInteractorTestBuilder()
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
