import XCTest

class NewsTests: UIAutomationTestCase {
    
    func testMessagesListingDoesNotAppearInSecondaryPane() throws {
        try controller.skipIfTablet()
        
        XCUIDevice.shared.orientation = .portrait
        controller.app.launch()
        controller.transitionToContent()
        try controller.naivgateToMessages()
        XCUIDevice.shared.orientation = .landscapeLeft
        
        let messagesNavigationBar = controller.app.navigationBars["Messages"]
        XCTAssertTrue(messagesNavigationBar.exists, "Messages should still be visible when rotated into landscape")
        
        let newsNavigationBar = controller.app.navigationBars["News"]
        XCTAssertFalse(newsNavigationBar.exists, "Messages should be inserted into the primary pane")
    }
    
}
