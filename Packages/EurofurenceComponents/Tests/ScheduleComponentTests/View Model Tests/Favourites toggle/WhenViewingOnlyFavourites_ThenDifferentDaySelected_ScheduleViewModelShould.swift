import EurofurenceModel
import ScheduleComponent
import XCTest
import XCTEurofurenceModel

class WhenViewingOnlyFavourites_ThenDifferentDaySelected_ScheduleViewModelShould: XCTestCase {
    
    func testMaintainFavouritesSubspecificationWithNewDay() throws {
        let days: [Day] = .random
        let randomDay = days.randomElement()
        let eventsService = FakeScheduleRepository()
        let context = ScheduleViewModelFactoryTestBuilder().with(eventsService).build()
        eventsService.simulateDaysChanged(days)
        let viewModel = context.makeViewModel()
        viewModel?.toggleFavouriteFilteringState()
        viewModel?.showEventsForDay(at: randomDay.index)
        
        let schedule = try XCTUnwrap(context.eventsService.schedule(for: "Schedule"))
        let expected = EventsOccurringOnDaySpecification(day: randomDay.element) && IsFavouriteEventSpecification()
        
        XCTAssertEqual(expected.eraseToAnySpecification(), schedule.specification)
    }
    
}
