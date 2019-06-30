@testable import Eurofurence
import EurofurenceModelTestDoubles
import XCTest

class WhenResumingViewEventIntent: XCTestCase {

    func testTheIntentIsResumed() {
        let contentRouter = CapturingContentRouter()
        let intentResumer = ActivityResumer(contentLinksService: StubContentLinksService(), contentRouter: contentRouter)
        let event = FakeEvent.random
        let eventIntentDefinition = ViewEventIntentDefinition(identifier: event.identifier, eventName: event.title)
        let eventIntent = StubEventIntentDefinitionProviding(eventIntentDefinition: eventIntentDefinition)
        let activity = IntentActivityDescription(intent: eventIntent)
        let resumed = intentResumer.resume(activity: activity)
        
        XCTAssertTrue(resumed)
        XCTAssertEqual(event.identifier, contentRouter.resumedEvent)
    }

}
