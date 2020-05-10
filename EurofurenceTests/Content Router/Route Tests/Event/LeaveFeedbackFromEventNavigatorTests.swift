import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class LeaveFeedbackFromEventNavigatorTests: XCTestCase {
    
    func testRoutesToEventFeedback() throws {
        let router = FakeContentRouter()
        let navigator = LeaveFeedbackFromEventNavigator(router: router)
        let event = EventIdentifier.random
        navigator.eventDetailComponentDidRequestPresentationToLeaveFeedback(for: event)
        
        router.assertRouted(to: EventFeedbackContentRepresentation(identifier: event))
    }

}
