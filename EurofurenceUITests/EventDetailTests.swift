import XCTest

class EventDetailTests: UIAutomationTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        controller.app.launch()
        controller.transitionToContent()
        XCUIDevice.shared.orientation = .landscapeLeft
        controller.tapTab(.schedule)
        try controller.tapKnownEvent()
    }
    
    func testNavigationTitle() {
        let navigationTitle = controller
            .app
            .staticTexts
            .matching(identifier: "org.eurofurence.event.navigationTitle")
            .firstMatch
        
        XCTAssertFalse(navigationTitle.exists)
        
        controller.app.tables["org.eurofurence.EventDetail.table"].firstMatch.swipeUp()
        
        XCTAssertTrue(navigationTitle.exists)
    }

}
