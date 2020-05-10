@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenEventTransitionsFromNonFavouriteToFavourite_EventViewModelShould: XCTestCase {

    func testNotifyTheObserver() {
        let eventsService = FakeEventsService()
        let event = FakeEvent.random
        eventsService.allEvents = [event]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        context.makeViewModel()
        let eventViewModel = context.eventsViewModels.first?.events.first
        let observer = CapturingScheduleEventViewModelObserver()
        eventViewModel?.add(observer)
        event.favourite()
        
        XCTAssert(eventViewModel?.isFavourite == true)
        XCTAssertEqual(.favourited, observer.state)
    }

}
