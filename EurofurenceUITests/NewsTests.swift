import XCTest

class NewsTests: UIAutomationTestCase {
    
    func testMessagesListingDoesNotAppearInSecondaryPane() throws {
        // TODO: Reenable once support for new IDP has been implemented
        throw XCTSkip("Login feature disabled due to deprecation.")
        
        try controller.skipIfTablet()
        
        XCUIDevice.shared.orientation = .portrait
        controller.app.launch()
        controller.transitionToContent()
        try controller.navigateToMessages()
        XCUIDevice.shared.orientation = .landscapeLeft
        
        let messagesNavigationBar = controller.app.navigationBars["Messages"]
        XCTAssertTrue(messagesNavigationBar.exists, "Messages should still be visible when rotated into landscape")
        
        let newsNavigationBar = controller.app.navigationBars["News"]
        XCTAssertFalse(newsNavigationBar.exists, "Messages should be inserted into the primary pane")
    }
    
    func testSigningOutWhileViewingMesssagesInLandscape() throws {
        // TODO: Reenable once support for new IDP has been implemented
        throw XCTSkip("Login feature disabled due to deprecation.")
        
        XCUIDevice.shared.orientation = .landscapeLeft
        controller.app.launch()
        controller.transitionToContent()
        
        try XCTSkipIf(controller.app.navigationBars.count == 1, "Only supported for devices in split view")
        
        let flow = try controller.navigateToMessages()
        
        if flow == .authenticated {
            // Due to a bug in the way the Accessibility APIs try and find the logout button after showing an alert,
            // we can't deterministically run this test without restarting the app first.
            controller.app.terminate()
            controller.app.launch()
            controller.transitionToContent()
            try controller.navigateToMessages()
        }
        
        let firstMessage = controller.app.cells.firstMatch
        try XCTSkipIf(!firstMessage.exists, "No messages in the account available for testing")
        
        firstMessage.tap()
        
        let logoutButton = controller.app.navigationBars.buttons["org.eurofurence.messages.logout-button"]
        logoutButton.tap()
        
        try controller.waitForCellWithText("You are currently not logged in")
        
        XCTAssertEqual(
            2,
            controller.app.navigationBars.count,
            "On logout, the News secondary placeholder should be embedded within a navigation controller"
        )
    }
    
}
