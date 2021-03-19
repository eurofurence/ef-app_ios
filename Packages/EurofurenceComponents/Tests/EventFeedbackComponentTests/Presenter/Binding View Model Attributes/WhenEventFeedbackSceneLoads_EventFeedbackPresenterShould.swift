import EventFeedbackComponent
import XCTest

class WhenEventFeedbackSceneLoads_EventFeedbackPresenterShould: XCTestCase {
    
    var context: EventFeedbackPresenterTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = EventFeedbackPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
    }
    
    func testBindHeadingAttributes() {
        assertTitleBound()
        assertEventTimeBound()
        assertEventLocationBound()
        assertEventHostBound()
    }
    
    func testShowTheFeedbackForm() {
        XCTAssertEqual(context.scene.feedbackState, .feedbackForm)
    }
    
    private func assertTitleBound() {
        XCTAssertEqual(context.event.title, context.scene.capturedViewModel?.eventTitle)
    }
    
    private func assertEventTimeBound() {
        let dayOfWeek = context.stubbedDayOfWeekString
        let startTime = context.stubbedStartTimeString
        let endTime = context.stubbedEndTimeString
        let expected = "\(dayOfWeek) from \(startTime) to \(endTime)"
        
        XCTAssertEqual(expected, context.scene.capturedViewModel?.eventDayAndTime)
    }
    
    private func assertEventLocationBound() {
        let expected = context.event.room.name
        XCTAssertEqual(expected, context.scene.capturedViewModel?.eventLocation)
    }
    
    private func assertEventHostBound() {
        let expected = "Hosted by \(context.event.hosts)"
        XCTAssertEqual(expected, context.scene.capturedViewModel?.eventHosts)
    }

}
