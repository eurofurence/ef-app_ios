import EurofurenceModel
import XCTest

class WhenResolvingEventByIdentifier_ForEventThatDoesNotExist_ApplicationShould: XCTestCase {

    func testReturnNil() {
        let context = EurofurenceSessionTestBuilder().build()
        let event = context.eventsService.makeEventsSchedule().fetchEvent(identifier: .random)

        XCTAssertNil(event)
    }

}
