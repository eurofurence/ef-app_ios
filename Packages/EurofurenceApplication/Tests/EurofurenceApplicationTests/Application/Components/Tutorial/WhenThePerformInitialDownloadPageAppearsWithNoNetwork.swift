import EurofurenceApplication
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
        
        XCTAssertEqual(context.alertRouter.presentedAlertTitle, .noNetworkAlertTitle)
        XCTAssertEqual(context.alertRouter.presentedAlertMessage, .noNetworkAlertMessage)
        XCTAssertEqual(1, context.alertRouter.presentedActions.count)
        XCTAssertEqual(action?.title, .ok)
    }

}
