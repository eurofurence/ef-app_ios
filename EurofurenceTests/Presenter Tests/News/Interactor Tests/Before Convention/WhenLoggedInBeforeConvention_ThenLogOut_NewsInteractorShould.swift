@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_ThenLogOut_NewsInteractorShould: XCTestCase {

    func testUpdateTheDelegateWithLoggedOutUserWidget() {
        let authenticationService = FakeAuthenticationService.loggedInService()
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(authenticationService)
            .build()
        context.subscribeViewModelUpdates()
        authenticationService.notifyObserversUserDidLogout()

        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
