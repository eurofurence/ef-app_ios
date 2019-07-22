@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRecordingEventInteraction: XCTestCase {
    
    func testTheEventInteractionIsRecordedWithBriefSummary() {
        let event = FakeEvent.random
        let eventsService = FakeEventsService()
        eventsService.events = [event]
        let eventIntentDonor = CapturingEventIntentDonor()
        let tracer = SystemEventInteractionsRecorder(eventsService: eventsService, eventIntentDonor: eventIntentDonor)
        _ = tracer.makeInteraction(for: event.identifier)
        
        let expected = ViewEventIntentDefinition(identifier: event.identifier, eventName: event.title)
        XCTAssertEqual(expected, eventIntentDonor.donatedEventIntentDefinition)
    }
    
}
