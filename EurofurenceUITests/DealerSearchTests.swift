import XCTest

class DealerSearchTests: UIAutomationTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        controller.app.launch()
        controller.transitionToContent()
        controller.tapTab(.dealers)
        controller.app.tables.firstMatch.swipeDown()
        controller.app.searchFields.firstMatch.tap()
    }
    
    func testDoesNotCrashWhenDismissingSearch_BUG() {
        controller.app.buttons["Cancel"].firstMatch.tap()
    }

}
