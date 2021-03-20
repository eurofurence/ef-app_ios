import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenUnfavouritingEvent_EventViewModelShould: XCTestCase {

    func testUnfavouriteTheEvent() {
        let eventsService = FakeEventsService()
        let event = FakeEvent.random
        event.favourite()
        eventsService.allEvents = [event]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        eventViewModel?.unfavourite()
        
        XCTAssertEqual(.unfavourited, event.favouritedState)
    }

}
