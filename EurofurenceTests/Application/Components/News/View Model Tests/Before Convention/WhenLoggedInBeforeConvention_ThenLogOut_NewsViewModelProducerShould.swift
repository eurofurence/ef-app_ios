import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_ThenLogOut_NewsViewModelProducerShould: XCTestCase {

    func testUpdateTheDelegateWithLoggedOutUserWidget() throws {
        let authenticationService = FakeAuthenticationService.loggedInService()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(authenticationService)
            .build()
        context.subscribeViewModelUpdates()
        authenticationService.notifyObserversUserDidLogout()

        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
