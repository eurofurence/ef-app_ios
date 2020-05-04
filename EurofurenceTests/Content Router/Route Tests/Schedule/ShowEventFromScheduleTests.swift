import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class ShowEventFromScheduleTests: XCTestCase {
    
    func testShowingEvent() {
        let router = FakeContentRouter()
        let navigator = ShowEventFromSchedule(router: router)
        let event = EventIdentifier.random
        navigator.scheduleModuleDidSelectEvent(identifier: event)
        
        router.assertRouted(to: EventContentRepresentation(identifier: event))
    }

}
