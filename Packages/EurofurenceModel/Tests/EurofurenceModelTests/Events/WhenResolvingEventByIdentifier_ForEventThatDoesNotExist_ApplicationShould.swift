import EurofurenceModel
import XCTest

class WhenResolvingEventByIdentifier_ForEventThatDoesNotExist_ApplicationShould: XCTestCase {

    func testReturnNil() {
        let context = EurofurenceSessionTestBuilder().build()
        let event = context.eventsService.loadSchedule(tag: "Test").loadEvent(identifier: .random)

        XCTAssertNil(event)
    }

}
