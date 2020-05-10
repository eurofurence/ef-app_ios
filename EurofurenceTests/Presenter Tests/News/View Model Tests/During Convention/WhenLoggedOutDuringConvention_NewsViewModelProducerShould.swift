@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenLoggedOutDuringConvention_NewsViewModelProducerShould: XCTestCase {

    func testProduceViewModelWithMessagesPrompt_Announcements_RunningEvents_UpcomingEvents_AndFavouriteEvents() {
        let eventsService = FakeEventsService()
        let runningEvents = [FakeEvent].random(minimum: 3)
        let upcomingEvents = [FakeEvent].random(minimum: 3)
        eventsService.runningEvents = runningEvents
        eventsService.upcomingEvents = upcomingEvents
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
            .hasRunningEvents()
            .hasFavouriteEvents()
            .verify()
    }

    func testFetchTheUpcomingEventAtTheSpecifiedIndexPath() {
        let eventsService = FakeEventsService()
        let upcomingEvents = [FakeEvent].random
        eventsService.upcomingEvents = upcomingEvents
        let context = DefaultNewsViewModelProducerTestBuilder()
            .with(FakeAuthenticationService.loggedOutService())
            .with(FakeAnnouncementsService(announcements: [StubAnnouncement].random))
            .with(StubConventionCountdownService(countdownState: .countdownElapsed))
            .with(eventsService)
            .build()
        context.subscribeViewModelUpdates()

        let randomEvent = upcomingEvents.randomElement()
        let indexPath = IndexPath(item: randomEvent.index, section: 2)
        context.assert().thatModel().at(indexPath: indexPath, is: .event(randomEvent.element))
    }

}
