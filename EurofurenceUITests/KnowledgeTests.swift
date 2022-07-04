import XCTest

class KnowledgeTests: UIAutomationTestCase {
    
    func testKnowledgeEntriesDoesNotAppearInSecondaryPane() throws {
        try controller.skipIfTablet()
        
        XCUIDevice.shared.orientation = .portrait
        controller.app.launch()
        controller.transitionToContent()
        controller.tapTab(.information)
        try controller.tapCellWithText("General Information")
        XCUIDevice.shared.orientation = .landscapeLeft
        
        try XCTSkipIf(controller.app.navigationBars.count < 2, "Only applies to phones using split view in landscape")
        
        let generalInformationTitle = controller.app.navigationBars["General Information"]
        
        XCTAssertTrue(
            generalInformationTitle.exists,
            "General Information should still be presented after rotating from portrait to landscape"
        )
        
        let informationNavigationTitle = controller.app.navigationBars["Information"]
        XCTAssertFalse(informationNavigationTitle.exists, "General Information should override the primary pane")
        
        controller.assertPlaceholderVisible()
    }
    
}
