import ComponentBase
import EurofurenceModel
import EventDetailComponent
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class WhenRecordingEventInteraction: XCTestCase {
    
    var event: FakeEvent!
    
    var interaction: Interaction?
    var eventIntentDonor: CapturingEventIntentDonor!
    var producedActivity: FakeActivity?
    
    override func setUp() {
        super.setUp()
        
        event = FakeEvent.random
        let eventsService = FakeScheduleRepository()
        eventsService.events = [event]
        eventIntentDonor = CapturingEventIntentDonor()
        let activityFactory = FakeActivityFactory()
        let tracer = SystemEventInteractionsRecorder(
            eventsService: eventsService,
            eventIntentDonor: eventIntentDonor,
            activityFactory: activityFactory
        )
        
        interaction = tracer.makeInteraction(for: event.identifier)
        producedActivity = activityFactory.producedActivity
    }
    
    func testEventActivityIsMade() {
        XCTAssertEqual("org.eurofurence.activity.view-event", producedActivity?.activityType)
        XCTAssertEqual("View event '\(event.title)'", producedActivity?.title)
        XCTAssertEqual(event.shareableURL, producedActivity?.url)
        XCTAssertEqual(true, producedActivity?.supportsPublicIndexing)
        XCTAssertEqual(false, producedActivity?.supportsLocalIndexing)
    }
    
    func testDonatingInteraction() {
        XCTAssertNil(eventIntentDonor.donatedEventIntentDefinition)
        
        interaction?.donate()
        
        XCTAssertEqual(
            ViewEventIntentDefinition(identifier: event.identifier, eventName: event.title),
            eventIntentDonor.donatedEventIntentDefinition
        )
    }
    
    func testTogglingInteractionActivationChangesCurrentStateOfActivity() {
        XCTAssertEqual(.unset, producedActivity?.state)
        
        interaction?.activate()
        
        XCTAssertEqual(.current, producedActivity?.state)
        
        interaction?.deactivate()
        
        XCTAssertEqual(.resignedCurrent, producedActivity?.state)
    }
    
}
