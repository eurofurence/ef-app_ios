import EurofurenceApplication
import EurofurenceModel
import EventFeedbackComponent
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class LeaveFeedbackFromEventNavigatorTests: XCTestCase {
    
    func testRoutesToEventFeedback() throws {
        let router = FakeContentRouter()
        let navigator = LeaveFeedbackFromEventNavigator(router: router)
        let event = EventIdentifier.random
        navigator.eventDetailComponentDidRequestPresentationToLeaveFeedback(for: event)
        
        router.assertRouted(to: EventFeedbackContentRepresentation(identifier: event))
    }

}
