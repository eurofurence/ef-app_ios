import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenLoggedOutBeforeConvention_ThenLogIn_NewsViewModelProducerShould: XCTestCase {

    func testUpdateTheDelegateWithLoggedInUserWidget() throws {
        let authenticationService = FakeAuthenticationService.loggedOutService()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAnnouncementsRepository(announcements: [FakeAnnouncement].random))
            .with(authenticationService)
            .build()
        context.subscribeViewModelUpdates()
        let user = User.random
        authenticationService.notifyObserversUserDidLogin(user)

        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
