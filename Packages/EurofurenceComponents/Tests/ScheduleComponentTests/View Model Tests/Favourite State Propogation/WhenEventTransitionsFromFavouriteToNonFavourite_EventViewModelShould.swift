import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenEventTransitionsFromFavouriteToNonFavourite_EventViewModelShould: XCTestCase {

    func testNotifyTheObserver() {
        let eventsService = FakeScheduleRepository()
        let event = FakeEvent.random
        event.favourite()
        eventsService.allEvents = [event]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        let observer = CapturingScheduleEventViewModelObserver()
        eventViewModel?.add(observer)
        event.unfavourite()
        
        XCTAssert(eventViewModel?.isFavourite == false)
        XCTAssertEqual(.unfavourited, observer.state)
    }

}
