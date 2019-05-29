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
        let tracer = IntentBasedEventInteractionRecorder(eventsService: eventsService, eventIntentDonor: eventIntentDonor)
        tracer.recordInteraction(for: event.identifier)
        
        let expected = EventIntentTraits(identifier: event.identifier,
                                        title: event.title,
                                        subtitle: event.room.name,
                                        startTime: event.startDate,
                                        endTime: event.endDate)
        XCTAssertEqual(expected, eventIntentDonor.donatedEventIntentTraits)
    }

}
