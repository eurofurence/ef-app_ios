import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenFavouritingEvent_EventViewModelShould: XCTestCase {

    func testFavouriteTheEvent() {
        let eventsService = FakeScheduleRepository()
        let event = FakeEvent.random
        eventsService.allEvents = [event]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        eventViewModel?.favourite()
        
        XCTAssertEqual(.favourited, event.favouritedState)
    }

}
