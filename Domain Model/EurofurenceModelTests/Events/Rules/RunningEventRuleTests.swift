import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class RunningEventRuleTests: XCTestCase {
    
    func testEventHasStarted() {
        let now = Date()
        let clock = StubClock(currentDate: now)
        let event = FakeEvent.random
        event.startDate = now.addingTimeInterval(-10)
        event.endDate = now.addingTimeInterval(100)
        let rule = RunningEventRule(clock: clock)
        
        XCTAssertTrue(rule.isSatisfied(by: event), "An event that has started should be considered running")
    }
    
    func testEventHasNotStarted() {
        let now = Date()
        let clock = StubClock(currentDate: now)
        let event = FakeEvent.random
        event.startDate = now.addingTimeInterval(10)
        event.endDate = now.addingTimeInterval(100)
        let rule = RunningEventRule(clock: clock)
        
        XCTAssertFalse(rule.isSatisfied(by: event), "An event that has not started should not be considered running")
    }
    
    func testEventHasFinished() {
        let now = Date()
        let clock = StubClock(currentDate: now)
        let event = FakeEvent.random
        event.startDate = now.addingTimeInterval(-100)
        event.endDate = now.addingTimeInterval(-10)
        let rule = RunningEventRule(clock: clock)

        XCTAssertFalse(rule.isSatisfied(by: event), "An event that has finished should not be considered running")
    }

}
