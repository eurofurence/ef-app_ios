import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedInBeforeConvention_ThenPersonalMessageIsReceived_NewsViewModelProducerShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_DaysUntilConvention_AndAnnouncements() throws {
        let privateMessagesService = CapturingPrivateMessagesService()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedInService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(privateMessagesService)
            .build()
        context.subscribeViewModelUpdates()
        let unreadCount = Int.random
        privateMessagesService.notifyUnreadCountDidChange(to: unreadCount)

        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasConventionCountdown()
            .hasAnnouncements()
            .verify()
    }

}
