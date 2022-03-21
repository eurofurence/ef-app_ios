import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenLoggedOutDuringConvention_WithNoUpcomingEvents_NewsViewModelProducerShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_Announcements_RunningEvents_AndFavouriteEvents() throws {
        let eventsService = FakeScheduleRepository()
        let upcomingEvents = [Event]()
        eventsService.runningEvents = [FakeEvent].random(minimum: 3)
        eventsService.upcomingEvents = upcomingEvents
        eventsService.stubSomeFavouriteEvents()
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedOutService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(StubConventionCountdownService(countdownState: .countdownElapsed))
            .with(eventsService)
            .build()
        context.subscribeViewModelUpdates()

        try context.assert()
            .thatViewModel()
            .hasYourEurofurence()
            .hasAnnouncements()
            .hasRunningEvents()
            .hasFavouriteEvents()
            .verify()
    }

}
