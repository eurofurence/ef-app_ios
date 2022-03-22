import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class EventsOccurringOnDaySpecificationTests: XCTestCase {
    
    func testEventOccursTodayAndIsHappeningRightNow() {
        let now = Date()
        let inHalfAnHour = now.addingTimeInterval(1800)
        let inOneHour = now.addingTimeInterval(3600)
        let event = FakeEvent.random
        event.startDate = now
        event.endDate = inOneHour
        let day = Day(date: inHalfAnHour)
        let specification = EventsOccurringOnDaySpecification(day: day)
        
        XCTAssertTrue(
            specification.isSatisfied(by: event),
            "The event is straddling when the day begins, satisfying the specification"
        )
    }
    
    func testEventDoesNotOccurToday() {
        let now = Date()
        let inJustOverOneDay = now.addingTimeInterval((3600 * 24) + 10)
        let event = FakeEvent.random
        event.startDate = inJustOverOneDay
        event.endDate = inJustOverOneDay.addingTimeInterval(1)
        let day = Day(date: now)
        let specification = EventsOccurringOnDaySpecification(day: day)
        
        XCTAssertFalse(
            specification.isSatisfied(by: event),
            "The event starts in over 24 hours from the day provided to the specification"
        )
    }
    
    func testEventHasOccurredToday() throws {
        let now = Date()
        let components = Calendar.current.dateComponents(in: .current, from: now)
        var earlyTodayComponents = components
        earlyTodayComponents.hour = 1
        let earlyToday = try XCTUnwrap(earlyTodayComponents.date)
        
        var middayComponents = components
        middayComponents.hour = 12
        let midday = try XCTUnwrap(middayComponents.date)
        
        let event = FakeEvent.random
        event.startDate = earlyToday
        event.endDate = earlyToday.addingTimeInterval(3600)
        let day = Day(date: midday)
        let specification = EventsOccurringOnDaySpecification(day: day)
        
        XCTAssertTrue(
            specification.isSatisfied(by: event),
            "The event started on the specified day, ignoring hours and minutes"
        )
    }
    
    func testEventHasOccurredToday_SpecificToMonth() throws {
        let now = Date()
        let components = Calendar.current.dateComponents(in: .current, from: now)
        var earlyTodayComponents = components
        earlyTodayComponents.hour = 1
        earlyTodayComponents.day = 1
        earlyTodayComponents.month = 1
        let earlyToday = try XCTUnwrap(earlyTodayComponents.date)
        
        var middayComponents = components
        middayComponents.hour = 12
        middayComponents.day = 1
        middayComponents.month = 2
        let midday = try XCTUnwrap(middayComponents.date)
        
        let event = FakeEvent.random
        event.startDate = earlyToday
        event.endDate = earlyToday.addingTimeInterval(3600)
        let day = Day(date: midday)
        let specification = EventsOccurringOnDaySpecification(day: day)
        
        XCTAssertFalse(
            specification.isSatisfied(by: event),
            "The event started on the same day but in a different month"
        )
    }
    
    func testEventHasOccurredToday_SpecificToYear() throws {
        let now = Date()
        let components = Calendar.current.dateComponents(in: .current, from: now)
        var earlyTodayComponents = components
        earlyTodayComponents.year = 2022
        earlyTodayComponents.month = 1
        earlyTodayComponents.day = 1
        earlyTodayComponents.hour = 1
        let earlyToday = try XCTUnwrap(earlyTodayComponents.date)
        
        var middayComponents = earlyTodayComponents
        middayComponents.year = 2021
        middayComponents.yearForWeekOfYear = 2021
        middayComponents.hour = 12
        let midday = try XCTUnwrap(middayComponents.date)
        
        let event = FakeEvent.random
        event.startDate = earlyToday
        event.endDate = earlyToday.addingTimeInterval(3600)
        let day = Day(date: midday)
        let specification = EventsOccurringOnDaySpecification(day: day)
        
        XCTAssertFalse(
            specification.isSatisfied(by: event),
            "The event started on the same day in the same month but in different years"
        )
    }
    
}
