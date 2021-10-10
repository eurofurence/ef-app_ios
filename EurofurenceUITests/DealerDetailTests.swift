import XCTest

class DealerDetailTests: UIAutomationTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        controller.app.launch()
        controller.transitionToContent()
        controller.tapTab(.dealers)
        try controller.tapKnownDealer()
    }
    
    func testNavigationTitle() {
        let navigationTitle = controller
            .app
            .staticTexts
            .matching(identifier: "org.eurofurence.dealer.navigationTitle")
            .firstMatch
        
        XCTAssertFalse(navigationTitle.exists)
        
        controller
            .app
            .tables
            .cells
            .containing(.staticText, identifier: "The Official Eurofurence Shop")
            .element
            .swipeUp()
        
        XCTAssertTrue(navigationTitle.exists)
    }

}
