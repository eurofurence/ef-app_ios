import EurofurenceApplication
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class ScheduleSubrouterTests: XCTestCase {
    
    func testShowingEvent() {
        let router = FakeContentRouter()
        let navigator = ScheduleSubrouter(router: router)
        let event = EventIdentifier.random
        navigator.scheduleComponentDidSelectEvent(identifier: event)
        
        router.assertRouted(to: EventContentRepresentation(identifier: event))
    }
    
    func testLeavingEventFeedback() {
        let router = FakeContentRouter()
        let navigator = ScheduleSubrouter(router: router)
        let event = EventIdentifier.random
        navigator.scheduleComponentDidRequestPresentationToLeaveFeedback(for: event)
        
        router.assertRouted(to: EventFeedbackContentRepresentation(identifier: event))
    }

}
