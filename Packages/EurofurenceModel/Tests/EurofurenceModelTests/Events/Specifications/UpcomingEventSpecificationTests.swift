import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class UpcomingEventSpecificationTests: XCTestCase {
    
    func testEventStartsAfterCurrentTime() {
        let now = Date()
        let oneHour: TimeInterval = 3600
        let clock = StubClock(currentDate: now)
        let event = FakeEvent.random
        event.startDate = now.addingTimeInterval(1)
        let configuration = StubUpcomingEventConfiguration(intervalFromPresentForUpcomingEvents: oneHour)
        let rule = UpcomingEventSpecification(clock: clock, configuration: configuration)
        
        XCTAssertTrue(
            rule.isSatisfied(by: event),
            "Event is upcoming when it hasn't started yet, and is within the upcoming time interval"
        )
    }
    
    func testEventStartsBeforeCurrentTime() {
        let now = Date()
        let oneHour: TimeInterval = 3600
        let clock = StubClock(currentDate: now)
        let event = FakeEvent.random
        event.startDate = now.addingTimeInterval(-1)
        let configuration = StubUpcomingEventConfiguration(intervalFromPresentForUpcomingEvents: oneHour)
        let rule = UpcomingEventSpecification(clock: clock, configuration: configuration)
        
        XCTAssertFalse(
            rule.isSatisfied(by: event),
            "Event is no longer upcoming when it has started"
        )
    }
    
    func testEventStartsAfterUpcomingIntervalElapses() {
        let now = Date()
        let oneHour: TimeInterval = 3600
        let clock = StubClock(currentDate: now)
        let event = FakeEvent.random
        event.startDate = now.addingTimeInterval(oneHour + 1)
        let configuration = StubUpcomingEventConfiguration(intervalFromPresentForUpcomingEvents: oneHour)
        let rule = UpcomingEventSpecification(clock: clock, configuration: configuration)
        
        XCTAssertFalse(
            rule.isSatisfied(by: event),
            "Event is not upcoming when it will start after the upcoming event interval"
        )
    }
    
    struct StubUpcomingEventConfiguration: UpcomingEventConfiguration {
        
        var intervalFromPresentForUpcomingEvents: TimeInterval
        
    }

}
