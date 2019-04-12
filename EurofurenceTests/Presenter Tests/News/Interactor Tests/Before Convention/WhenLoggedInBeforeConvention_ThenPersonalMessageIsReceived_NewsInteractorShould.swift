@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_ThenPersonalMessageIsReceived_NewsInteractorShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_DaysUntilConvention_AndAnnouncements() {
        let privateMessagesService = CapturingPrivateMessagesService()
        let context = DefaultNewsInteractorTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(privateMessagesService)
            .build()
        context.subscribeViewModelUpdates()
        let unreadCount = Int.random
        privateMessagesService.notifyUnreadCountDidChange(to: unreadCount)

        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
