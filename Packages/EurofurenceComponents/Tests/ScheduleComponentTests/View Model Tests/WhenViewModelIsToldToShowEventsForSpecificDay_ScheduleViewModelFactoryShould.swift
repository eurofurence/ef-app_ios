import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenViewModelIsToldToShowEventsForSpecificDay_ScheduleViewModelFactoryShould: XCTestCase {

    func testTellTheScheduleToRestrictEventsToSpecifiedDay() throws {
        let days: [Day] = .random
        let randomDay = days.randomElement()
        let event = FakeEvent.random
        event.day = randomDay.element
        event.startDate = randomDay.element.date.addingTimeInterval(-10)
        event.endDate = randomDay.element.date.addingTimeInterval(10)
        
        let events: [FakeEvent] = [event, .random, .random]
        let eventsService = FakeScheduleRepository()
        eventsService.allEvents = events
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        eventsService.simulateDaysChanged(days)
        let viewModel = context.makeViewModel()
        viewModel?.showEventsForDay(at: randomDay.index)
        
        XCTAssertEqual(1, context.viewModelDelegate.eventsViewModels.count)
        
        let firstGroup = try XCTUnwrap(context.viewModelDelegate.eventsViewModels.first)
        
        XCTAssertEqual(1, firstGroup.events.count)
        
        let eventViewModel = try XCTUnwrap(firstGroup.events.first)
        
        XCTAssertEqual(event.title, eventViewModel.title)
    }

}
