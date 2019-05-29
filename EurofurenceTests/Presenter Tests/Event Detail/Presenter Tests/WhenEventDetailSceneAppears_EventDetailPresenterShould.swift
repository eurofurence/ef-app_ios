@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenEventDetailSceneAppears_EventDetailPresenterShould: XCTestCase {

    func testRecordTheUserWitnessedTheEvent() {
        let event = FakeEvent.random
        let context = EventDetailPresenterTestBuilder().build(for: event)
        
        XCTAssertNil(context.eventInteractionRecorder.witnessedEvent)
        
        context.simulateSceneDidLoad()
        
        XCTAssertEqual(context.eventInteractionRecorder.witnessedEvent, event.identifier)
    }

}
