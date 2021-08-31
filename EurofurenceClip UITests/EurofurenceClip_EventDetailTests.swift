import XCTest

class EurofurenceClip_EventDetailTests: UIAutomationTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        controller.app.launch()
        controller.app.tables.staticTexts["Fursuit Lounge"].tap()
    }
    
    func testNavigationTitle() {
        let navigationTitle = controller
            .app
            .staticTexts
            .matching(identifier: "org.eurofurence.event.navigationTitle")
            .firstMatch
        
        XCTAssertFalse(navigationTitle.exists)
        
        controller.app.tables.cells.containing(.staticText, identifier: "Share").element.swipeUp()
        
        XCTAssertTrue(navigationTitle.exists)
    }
    
}
