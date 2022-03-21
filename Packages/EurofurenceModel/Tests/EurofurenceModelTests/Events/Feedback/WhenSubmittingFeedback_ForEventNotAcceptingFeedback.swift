import EurofurenceModel
import XCTest
import XCTEurofurenceModel

class WhenSubmittingFeedback_ForEventNotAcceptingFeedback: XCTestCase {

    func testTheDelegateIsToldTheFeedbackFailed() {
        var characteristics = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = characteristics.events.changed.randomElement()
        var event = randomEvent.element
        event.isAcceptingFeedback = false
        characteristics.events.changed[randomEvent.index] = event
        let store = InMemoryDataStore(response: characteristics)
        let context = EurofurenceSessionTestBuilder().with(store).build()
        let schedule = context.services.events.loadSchedule()
        let entity = schedule.loadEvent(identifier: EventIdentifier(event.identifier))
        let delegate = CapturingEventFeedbackDelegate()
        entity?.prepareFeedback().submit(delegate)
        
        XCTAssertEqual(delegate.feedbackState, .failed)
    }

}
