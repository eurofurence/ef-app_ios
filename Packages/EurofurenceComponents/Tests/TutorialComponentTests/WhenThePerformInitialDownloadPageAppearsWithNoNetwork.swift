import TutorialComponent
import XCTest

class WhenThePerformInitialDownloadPageAppearsWithNoNetwork: XCTestCase {

    var context: TutorialModuleTestBuilder.Context!
    
    override func setUp() {
        super.setUp()
        
        context = TutorialModuleTestBuilder()
            .with(NoNetwork())
            .with(UserAcknowledgedPushPermissions())
            .build()
    }
    
    func testAttemptingDownloadShowsNoNetworkAlert() {
        context.page.simulateTappingPrimaryActionButton()
        
        let action = context.alertRouter.presentedActions.first
        
        XCTAssertEqual(context.alertRouter.presentedAlertTitle, "No Network")
        XCTAssertEqual(context.alertRouter.presentedAlertMessage, "Please connect to the internet and try again.")
        XCTAssertEqual(1, context.alertRouter.presentedActions.count)
        XCTAssertEqual(action?.title, "OK")
    }

}
