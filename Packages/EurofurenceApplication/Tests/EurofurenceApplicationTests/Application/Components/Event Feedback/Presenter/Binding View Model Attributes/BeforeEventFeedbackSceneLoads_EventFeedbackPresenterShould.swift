import EurofurenceApplication
import XCTest

class BeforeEventFeedbackSceneLoads_EventFeedbackPresenterShould: XCTestCase {

    func testNotBindEventTitle() {
        let context = EventFeedbackPresenterTestBuilder().build()
        XCTAssertNil(context.scene.capturedViewModel?.eventTitle)
    }

}
