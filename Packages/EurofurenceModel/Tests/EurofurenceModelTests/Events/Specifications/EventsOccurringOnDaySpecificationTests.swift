import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class EventsOccurringOnDaySpecificationTests: XCTestCase {
    
    func testEventOccursOnSameDay() {
        let day = Day(date: Date(), identifier: "ID")
        let event = FakeEvent.random
        event.startDate = day.date
        event.day = day
        
        let specification = EventsOccurringOnDaySpecification(day: day)
        
        XCTAssertTrue(specification.isSatisfied(by: event), "Event occurs on the same day")
    }
    
    func testEventDoesNotOccursOnSameDay() {
        let eventDay = Day(date: Date(), identifier: "ID")
        let event = FakeEvent.random
        event.startDate = eventDay.date
        event.day = eventDay
        
        let criteriaDay = Day(date: Date(), identifier: "ID 2")
        
        let specification = EventsOccurringOnDaySpecification(day: criteriaDay)
        
        XCTAssertFalse(specification.isSatisfied(by: event), "Event does not occur on the same day")
    }
    
}
