import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedOutDuringConvention_WithNoRunningEvents_NewsViewModelProducerShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_Announcements_UpcomingEvents_AndFavouriteEvents() {
        let eventsService = FakeEventsService()
        let runningEvents = [Event]()
        eventsService.runningEvents = runningEvents
        eventsService.upcomingEvents = [FakeEvent].random(minimum: 1)
        eventsService.stubSomeFavouriteEvents()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedOutService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(StubConventionCountdownService(countdownState: .countdownElapsed))
            .with(eventsService)
            .build()
        context.subscribeViewModelUpdates()

        context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasAnnouncements()
            .hasUpcomingEvents()
            .hasFavouriteEvents()
            .verify()
    }

}
