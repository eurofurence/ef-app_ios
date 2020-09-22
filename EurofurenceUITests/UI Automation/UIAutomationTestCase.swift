import XCTest

class UIAutomationTestCase: XCTestCase {
    
    let controller = AutomationController()

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }

}
