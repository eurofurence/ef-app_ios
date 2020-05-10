@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedOutBeforeConvention_ThenLogIn_NewsViewModelProducerShould: XCTestCase {

    func testUpdateTheDelegateWithLoggedInUserWidget() {
        let authenticationService = FakeAuthenticationService.loggedOutService()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(authenticationService)
            .build()
        context.subscribeViewModelUpdates()
        let user = User.random
        authenticationService.notifyObserversUserDidLogin(user)

        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
