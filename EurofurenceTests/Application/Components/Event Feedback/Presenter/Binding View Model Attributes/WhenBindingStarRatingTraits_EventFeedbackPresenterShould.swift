@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenBindingStarRatingTraits_EventFeedbackPresenterShould: XCTestCase {

    func testBindDefaultNumberOfStars() {
        let event = FakeEvent.random
        let defaultNumberOfStars = 3
        event.feedbackToReturn = FakeEventFeedback(rating: defaultNumberOfStars)
        let context = EventFeedbackPresenterTestBuilder().with(event).build()
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(defaultNumberOfStars, context.scene.capturedViewModel?.defaultEventStarRating)
    }

}
