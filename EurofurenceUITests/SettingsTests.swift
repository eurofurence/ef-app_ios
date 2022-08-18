import XCTest

class SettingsTests: UIAutomationTestCase {
    
    func testCanDismissSettings() throws {
        controller.app.launch()
        controller.transitionToContent()
        
        let settingsButton = controller.app.navigationBars.buttons["org.eurofurence.news.settings-button"].firstMatch
        XCTAssertTrue(settingsButton.isHittable, "Can't see Settings button in the News navigation bar")
        
        settingsButton.tap()
        
        let settingsTitle = controller.app.navigationBars.staticTexts["Select App Icon"].firstMatch
        XCTAssertTrue(settingsTitle.isHittable, "Can't see the Settings view after tapping the settings button")
        
        let cancelButton = controller.app.navigationBars.buttons["Cancel"].firstMatch
        XCTAssertTrue(cancelButton.isHittable, "Can't see a Cancel button in the Settings view")
        
        cancelButton.tap()
        
        XCTAssertFalse(settingsTitle.isHittable, "Expected not to still see the Settings view after tapping Cancel")
    }
    
}
