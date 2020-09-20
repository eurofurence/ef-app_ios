import XCTest

class DealerDetailTests: XCTestCase {
    
    private let controller = AutomationController()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        controller.app.launch()
        controller.transitionToContent()
        controller.tapTab(.dealers)
        controller.app.tables.staticTexts["Eurofurence Shop"].tap()
    }
    
    func testNavigationTitle() {
        let navigationTitle = controller.app.navigationBars["Eurofurence Shop"]
        
        XCTAssertFalse(navigationTitle.exists)
        
        controller.app.tables.cells.containing(.staticText, identifier: "Eurofurence Shop").element.swipeUp()
        
        XCTAssertTrue(navigationTitle.exists)
    }

}
