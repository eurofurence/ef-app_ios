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
        let activityFactory = FakeActivityFactory()
        let tracer = SystemEventInteractionsRecorder(eventsService: eventsService, eventIntentDonor: eventIntentDonor, activityFactory: activityFactory)
        _ = tracer.makeInteraction(for: event.identifier)
        
        let expected = ViewEventIntentDefinition(identifier: event.identifier, eventName: event.title)
        XCTAssertEqual(expected, eventIntentDonor.donatedEventIntentDefinition)
    }
    
    func testEventActivityIsMade() {
        let event = FakeEvent.random
        let eventsService = FakeEventsService()
        eventsService.events = [event]
        let eventIntentDonor = CapturingEventIntentDonor()
        let activityFactory = FakeActivityFactory()
        let tracer = SystemEventInteractionsRecorder(eventsService: eventsService, eventIntentDonor: eventIntentDonor, activityFactory: activityFactory)
        _ = tracer.makeInteraction(for: event.identifier)
        
        let producedActivity = activityFactory.producedActivity
        
        let expectedTitleFormat = NSLocalizedString("ViewEventFormatString", comment: "")
        let expectedTitle = String.localizedStringWithFormat(expectedTitleFormat, event.title)
        XCTAssertEqual("org.eurofurence.activity.view-event", producedActivity?.activityType)
        XCTAssertEqual(expectedTitle, producedActivity?.title)
        XCTAssertEqual(event.shareableURL, producedActivity?.url)
        XCTAssertEqual(true, producedActivity?.supportsPublicIndexing)
        XCTAssertEqual(false, producedActivity?.supportsLocalIndexing)
    }
    
    func testTogglingInteractionActivationChangesCurrentStateOfActivity() {
        let event = FakeEvent.random
        let eventsService = FakeEventsService()
        eventsService.events = [event]
        let eventIntentDonor = CapturingEventIntentDonor()
        let activityFactory = FakeActivityFactory()
        let tracer = SystemEventInteractionsRecorder(eventsService: eventsService, eventIntentDonor: eventIntentDonor, activityFactory: activityFactory)
        let interaction = tracer.makeInteraction(for: event.identifier)
        let producedActivity = activityFactory.producedActivity
        
        XCTAssertEqual(.unset, producedActivity?.state)
        
        interaction?.activate()
        
        XCTAssertEqual(.current, producedActivity?.state)
        
        interaction?.deactivate()
        
        XCTAssertEqual(.resignedCurrent, producedActivity?.state)
    }
    
}
