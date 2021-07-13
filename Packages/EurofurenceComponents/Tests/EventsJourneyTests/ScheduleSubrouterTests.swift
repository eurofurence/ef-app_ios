import EurofurenceModel
import EventDetailComponent
import EventFeedbackComponent
import EventsJourney
import XCTest
import XCTEurofurenceModel
import XCTRouter

class ScheduleSubrouterTests: XCTestCase {
    
    func testShowingEvent() {
        let router = FakeContentRouter()
        let navigator = ScheduleSubrouter(router: router)
        let event = EventIdentifier.random
        navigator.scheduleComponentDidSelectEvent(identifier: event)
        
        router.assertRouted(to: EventRouteable(identifier: event))
    }
    
    func testLeavingEventFeedback() {
        let router = FakeContentRouter()
        let navigator = ScheduleSubrouter(router: router)
        let event = EventIdentifier.random
        navigator.scheduleComponentDidRequestPresentationToLeaveFeedback(for: event)
        
        router.assertRouted(to: EventFeedbackRouteable(identifier: event))
    }

}
