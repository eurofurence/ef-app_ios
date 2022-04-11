import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenLoggedOutDuringConvention_WithNoRunningEvents_NewsViewModelProducerShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_Announcements_UpcomingEvents_AndFavouriteEvents() throws {
        let eventsService = FakeScheduleRepository()
        let runningEvents = [Event]()
        eventsService.runningEvents = runningEvents
        eventsService.upcomingEvents = [FakeEvent].random(minimum: 1)
        eventsService.stubSomeFavouriteEvents()
        eventsService.simulateDayChanged(to: .random)
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedOutService())
            .with(FakeAnnouncementsRepository(announcements: [FakeAnnouncement].random))
            .with(StubConventionCountdownService(countdownState: .countdownElapsed))
            .with(eventsService)
            .build()
        context.subscribeViewModelUpdates()

        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasAnnouncements()
            .hasUpcomingEvents()
            .hasFavouriteEvents()
            .verify()
    }

}
