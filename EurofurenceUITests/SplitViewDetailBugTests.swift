import XCTest

class SplitViewDetailBugTests: XCTestCase {

    func testPlaceholderNotVisibleWhenTransitioningFromAppToHomeToApp_BUG() throws {
        let controller = AutomationController()
        try XCTSkipIf(controller.isTablet, "Does not apply to tablets")
        
        // Test only applies to iPhones in portrait. Larger devices in landscape will show the placeholder as expected.
        XCUIDevice.shared.orientation = .portrait
        
        controller.app.launch()
        controller.transitionToContent()
        
        XCUIDevice.shared.press(.home)
        XCTAssertTrue(controller.app.wait(for: .runningBackground, timeout: 5), "App did not enter background state")
        
        controller.app.activate()
        controller.tapTab(.schedule)
        
        let placeholderImage = controller.app.images["org.eurofurence.NoContentPlaceholder.Placeholderimage"].firstMatch
        XCTAssertFalse(placeholderImage.exists)
    }
    
    func testContentDetailStillHasNavigationTitleWhenRotatingIntoLandscape_BUG() throws {
        let controller = AutomationController()
        try XCTSkipIf(controller.isPhone, "Does not apply to phones")
        
        controller.app.launch()
        controller.transitionToContent()
        
        XCUIDevice.shared.orientation = .portrait
        
        controller.tapTab(.schedule)
        try controller.tapKnownEvent()
        
        XCUIDevice.shared.orientation = .landscapeLeft
        
        let navigationBar = controller
            .app
            .navigationBars
        
        XCTAssertEqual(2, navigationBar.count)
    }

}
