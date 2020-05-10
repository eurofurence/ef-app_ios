@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRecordingEventInteraction: XCTestCase {
    
    var event: FakeEvent!
    
    var interaction: Interaction?
    var donatedIntent: ViewEventIntentDefinition?
    var producedActivity: FakeActivity?
    
    override func setUp() {
        super.setUp()
        
        event = FakeEvent.random
        let eventsService = FakeEventsService()
        eventsService.events = [event]
        let eventIntentDonor = CapturingEventIntentDonor()
        let activityFactory = FakeActivityFactory()
        let tracer = SystemEventInteractionsRecorder(
            eventsService: eventsService,
            eventIntentDonor: eventIntentDonor,
            activityFactory: activityFactory
        )
        
        interaction = tracer.makeInteraction(for: event.identifier)
        donatedIntent = eventIntentDonor.donatedEventIntentDefinition
        producedActivity = activityFactory.producedActivity
    }
    
    func testTheEventInteractionIsRecordedWithBriefSummary() {
        XCTAssertEqual(
            ViewEventIntentDefinition(identifier: event.identifier, eventName: event.title),
            donatedIntent
        )
    }
    
    func testEventActivityIsMade() {
        let expectedTitleFormat = NSLocalizedString("ViewEventFormatString", comment: "")
        let expectedTitle = String.localizedStringWithFormat(expectedTitleFormat, event.title)
        
        XCTAssertEqual(
            ViewEventIntentDefinition(identifier: event.identifier, eventName: event.title),
            donatedIntent
        )
        
        XCTAssertEqual("org.eurofurence.activity.view-event", producedActivity?.activityType)
        XCTAssertEqual(expectedTitle, producedActivity?.title)
        XCTAssertEqual(event.shareableURL, producedActivity?.url)
        XCTAssertEqual(true, producedActivity?.supportsPublicIndexing)
        XCTAssertEqual(false, producedActivity?.supportsLocalIndexing)
    }
    
    func testTogglingInteractionActivationChangesCurrentStateOfActivity() {
        XCTAssertEqual(.unset, producedActivity?.state)
        
        interaction?.activate()
        
        XCTAssertEqual(.current, producedActivity?.state)
        
        interaction?.deactivate()
        
        XCTAssertEqual(.resignedCurrent, producedActivity?.state)
    }
    
}
