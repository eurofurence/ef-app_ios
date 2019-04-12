@testable import Eurofurence
import XCTest

class WhenEventFeedbackSceneLoads_EventFeedbackPresenterShould: XCTestCase {
    
    var context: EventFeedbackPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
    }
    
    func testBindEventTitle() {
        XCTAssertEqual(context.event.title, context.scene.capturedViewModel?.eventTitle)
    }
    
    func testBindEventTime() {
        let formatString = String.eventFeedbackDayAndTimeFormat
        let expected = String.localizedStringWithFormat(formatString,
                                                        context.stubbedDayOfWeekString,
                                                        context.stubbedStartTimeString,
                                                        context.stubbedEndTimeString)
        
        XCTAssertEqual(expected, context.scene.capturedViewModel?.eventDayAndTime)
    }

}
