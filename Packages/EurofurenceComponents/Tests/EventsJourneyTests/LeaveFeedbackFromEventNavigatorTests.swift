import EurofurenceModel
import EventFeedbackComponent
import EventsJourney
import XCTest
import XCTEurofurenceModel
import XCTRouter

class LeaveFeedbackFromEventNavigatorTests: XCTestCase {
    
    func testRoutesToEventFeedback() throws {
        let router = FakeContentRouter()
        let navigator = LeaveFeedbackFromEventNavigator(router: router)
        let event = EventIdentifier.random
        navigator.eventDetailComponentDidRequestPresentationToLeaveFeedback(for: event)
        
        router.assertRouted(to: EventFeedbackRouteable(identifier: event))
    }

}
