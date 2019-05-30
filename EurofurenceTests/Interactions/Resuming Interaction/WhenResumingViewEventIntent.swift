@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingViewEventIntent: XCTestCase {

    func testTheIntentIsResumed() {
        let resumeResponseHandler = CapturingResumeIntentResponseHandler()
        let intentResumer = InteractionResumer(resumeResponseHandler: resumeResponseHandler)
        let event = FakeEvent.random
        let eventIntentDefinition = ViewEventIntentDefinition(identifier: event.identifier, eventName: event.title)
        let eventIntent = StubEventIntentDefinitionProviding(eventIntentDefinition: eventIntentDefinition)
        let resumed = intentResumer.resume(intent: eventIntent)
        
        XCTAssertTrue(resumed)
        XCTAssertEqual(event.identifier, resumeResponseHandler.resumedEvent)
    }

}
