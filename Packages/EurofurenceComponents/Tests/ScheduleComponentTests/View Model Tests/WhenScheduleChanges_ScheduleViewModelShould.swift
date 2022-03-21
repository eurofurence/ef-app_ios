import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenScheduleChanges_ScheduleViewModelShould: XCTestCase {

    func testUnhookEventObservationsFromTheOldEvents() {
        let oldEvent = FakeEvent.random
        let eventsService = FakeScheduleRepository()
        eventsService.allEvents = [oldEvent]
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
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
