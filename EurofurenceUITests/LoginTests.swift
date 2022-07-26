import XCTest

class LoginTests: UIAutomationTestCase {
    
    func testCanNavigateToScheduleAfterSigningIn_BUG() throws {
        XCUIDevice.shared.orientation = .portrait
        
        controller.app.launch()
        controller.transitionToContent()
        
        let runTest: () -> Void = { [controller] in
            // The bug manifests itself as touches not being intercepted by other UI elements, including the tab bar.
            // If we try to move another tab, we should then see its title.
            controller.tapTab(.schedule)
            
            let scheduleTitle = controller.app.staticTexts["Schedule"]
            XCTAssertTrue(scheduleTitle.exists, "Should switch to Schedule tab when tapping tab item")
        }
        
        switch try controller.ensureAuthenticated() {
        case .alreadyAuthenticated:
            try controller.navigateToMessages()
            
            let signOutButton = controller.app.buttons["Logout"]
            signOutButton.tap()
            
            _ = controller.signInPrompt.waitForExistence(timeout: 10)
            _ = try controller.ensureAuthenticated()
            
            runTest()
            
        case .authenticated:
            runTest()
        }
    }
}
