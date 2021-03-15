import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenFavouritingEvent_EventViewModelShould: XCTestCase {

    func testFavouriteTheEvent() {
        let eventsService = FakeEventsService()
        let event = FakeEvent.random
        eventsService.allEvents = [event]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        eventViewModel?.favourite()
        
        XCTAssertEqual(.favourited, event.favouritedState)
    }

}
