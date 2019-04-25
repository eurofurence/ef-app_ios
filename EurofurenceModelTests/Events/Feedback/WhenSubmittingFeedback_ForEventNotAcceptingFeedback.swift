import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSubmittingFeedback_ForEventNotAcceptingFeedback: XCTestCase {

    func testTheDelegateIsToldTheFeedbackFailed() {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = characteristics.events.changed.randomElement()
        var event = randomEvent.element
        event.isAcceptingFeedback = false
        characteristics.events.changed[randomEvent.index] = event
        let store = FakeDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(store).build()
        let entity = context.services.events.fetchEvent(identifier: EventIdentifier(event.identifier))
        let delegate = CapturingEventFeedbackDelegate()
        entity?.prepareFeedback().submit(delegate)
        
        XCTAssertEqual(delegate.feedbackState, .failed)
    }

}
