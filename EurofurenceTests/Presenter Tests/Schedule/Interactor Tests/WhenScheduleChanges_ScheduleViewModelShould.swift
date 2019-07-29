@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenScheduleChanges_ScheduleViewModelShould: XCTestCase {

    func testUnhookEventObservationsFromTheOldEvents() {
        let oldEvent = FakeEvent.random
        let eventsService = FakeEventsService()
        eventsService.allEvents = [oldEvent]
        let context = ScheduleInteractorTestBuilder().with(eventsService).build()
        context.makeViewModel()
        eventsService.lastProducedSchedule?.simulateEventsChanged([oldEvent])
        let oldViewModel = context.viewModelDelegate.eventsViewModels[0].events[0]
        let observer = CapturingScheduleEventViewModelObserver()
        oldViewModel.add(observer)
        
        let newEvent = FakeEvent.random
        eventsService.lastProducedSchedule?.simulateEventsChanged([newEvent])
        
        oldEvent.favourite()
        
        XCTAssertNotEqual(.favourited, observer.state)
    }

}
