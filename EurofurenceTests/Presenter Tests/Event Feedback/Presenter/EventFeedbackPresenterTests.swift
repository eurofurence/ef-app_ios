@testable import Eurofurence
import XCTest

class EventFeedbackPresenterTests: XCTestCase {
    
    var context: EventFeedbackPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
    }
    
    func testBindsEventTitle() {
        XCTAssertEqual(context.event.title, context.scene.capturedViewModel?.eventTitle)
    }
    
    func testBindsEventTime() {
        XCTAssertEqual(context.stubbedDayOfWeekString, context.scene.capturedViewModel?.eventDayAndTime)
    }

}
