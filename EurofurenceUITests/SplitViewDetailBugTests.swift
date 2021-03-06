import XCTest

class SplitViewDetailBugTests: XCTestCase {

    func testPlaceholderNotVisibleWhenTransitioningFromAppToHomeToApp_BUG() throws {
        let controller = AutomationController()
        try XCTSkipIf(controller.isTablet, "Does not apply to tablets")
        
        controller.app.launch()
        controller.transitionToContent()
        
        XCUIDevice.shared.press(.home)
        XCTAssertTrue(controller.app.wait(for: .runningBackground, timeout: 5), "App did not enter background state")
        
        controller.app.activate()
        controller.tapTab(.schedule)
        
        let placeholderImage = controller.app.images["org.eurofurence.NoContentPlaceholder.Placeholderimage"].firstMatch
        XCTAssertFalse(placeholderImage.exists)
    }

}
