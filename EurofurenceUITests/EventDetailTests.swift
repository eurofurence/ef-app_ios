import XCTest

class EventDetailTests: XCTestCase {
    
    private let controller = AutomationController()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        controller.app.launch()
        controller.transitionToContent()
        controller.tapTab(.schedule)
        controller.app.tables.staticTexts["Fursuit Lounge"].tap()
    }
    
    func testNavigationTitle() {
        let navigationTitle = controller.app.staticTexts.matching(identifier: "org.eurofurence.event.navigationTitle").firstMatch
        
        XCTAssertFalse(navigationTitle.exists)
        
        controller.app.tables.cells.containing(.staticText, identifier: "Share").element.swipeUp()
        
        XCTAssertTrue(navigationTitle.exists)
    }

}
