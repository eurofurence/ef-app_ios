import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class TodaysEventsSpecificationTests: XCTestCase {
    
    func testEventStartsToday() {
        assertEvent(
            starting: today,
            ending: today,
            satisfiesSpec: true,
            "Event starting today should satisfy the specification"
        )
    }
    
    func testEventStartsAndEndsYesterday() {
        assertEvent(
            starting: yesterday,
            ending: yesterday,
            satisfiesSpec: false,
            "Event starting and ending yesterday should not satisfy the specification"
        )
    }
    
    func testEventStartedYesterdayAndEndsToday() {
        assertEvent(
            starting: yesterday,
            ending: today,
            satisfiesSpec: true,
            "Event that runs into the morning from overnight should satisfy the specification"
        )
    }
    
    func testEventStartsAndEndsTomorrow() {
        assertEvent(
            starting: tomorrow,
            ending: tomorrow,
            satisfiesSpec: false,
            "Event starting and ending tomorrow should not satisfy the specification"
        )
    }
    
    func testEventStartsYesterdayAndEndsTomorrow() {
        assertEvent(
            starting: yesterday,
            ending: tomorrow,
            satisfiesSpec: true,
            "Event that runs throughout the day should satisfy the specification"
        )
    }
    
    func testEventStartsTodayAndEndsTomorrow_EndOfMonth() {
        assertEvent(
            starting: today,
            ending: firstOfNextMonth,
            satisfiesSpec: true,
            "Start and end dates should take months into account"
        )
    }
    
    private func assertEvent(
        starting startTime: Date,
        ending endTime: Date,
        satisfiesSpec expected: Bool,
        _ description: String,
        _ line: UInt = #line
    ) {
        let event = FakeEvent.random
        event.startDate = startTime
        event.endDate = endTime
        
        let clock = StubClock()
        clock.tickTime(to: today)
        let specification = TodaysEventsSpecification(clock: clock)
        
        let actual = specification.isSatisfied(by: event)
        
        XCTAssert(expected == actual, description)
    }
    
    private var oneDayInHours: TimeInterval {
        3600 * 24
    }
    
    private var today: Date {
        DateComponents(
            calendar: .current,
            year: 2019,
            month: 9,
            day: 29,
            hour: 12,
            minute: 0,
            second: 0
        ).date.unsafelyUnwrapped
    }
    
    private var tomorrow: Date {
        today.addingTimeInterval(oneDayInHours)
    }
    
    private var firstOfNextMonth: Date {
        DateComponents(
            calendar: .current,
            year: 2019,
            month: 10,
            day: 1,
            hour: 12,
            minute: 0,
            second: 0
        ).date.unsafelyUnwrapped
    }
    
    private var yesterday: Date {
        today.addingTimeInterval(oneDayInHours * -1)
    }
    
}
