import EurofurenceModel
import XCTest

class WhenFavouritingEvent_WithScheduleAndSearchControllerActive: XCTestCase {

    func testFavouritingEventInScheduleUpdatesCorrespondingEventInSearchController_BUG() throws {
        let context = EurofurenceSessionTestBuilder().build()
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let event = characteristics.events.changed.randomElement().element
        characteristics.events.changed = [event]
        let days = characteristics.conferenceDays.changed
        let dayForEvent = try XCTUnwrap(days.first(where: { $0.identifier == event.dayIdentifier }))
        characteristics.conferenceDays.changed = [dayForEvent]
        context.performSuccessfulSync(response: characteristics)
        let schedule = context.eventsService.loadSchedule(tag: "Test")
        let searchController = context.eventsService.makeEventsSearchController()
        
        let scheduleDelegate = CapturingScheduleDelegate()
        schedule.setDelegate(scheduleDelegate)
        let scheduleEvent = scheduleDelegate.events.first(where: { $0.identifier == EventIdentifier(event.identifier) })
        
        let searchControllerDelegate = CapturingEventsSearchControllerDelegate()
        searchController.setResultsDelegate(searchControllerDelegate)
        searchController.changeSearchTerm(event.title)
        let searchControllerEvent = searchControllerDelegate.capturedSearchResults.first(
            where: { $0.identifier == EventIdentifier(event.identifier) }
        )
        
        XCTAssertEqual(scheduleEvent?.identifier, searchControllerEvent?.identifier)
        
        let searchControllerEventDelegate = CapturingEventObserver()
        searchControllerEvent?.add(searchControllerEventDelegate)
        scheduleEvent?.favourite()
        
        XCTAssertEqual(.favourite, searchControllerEventDelegate.eventFavouriteState)
    }

}
