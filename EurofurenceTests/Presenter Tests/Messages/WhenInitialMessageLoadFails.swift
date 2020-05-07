@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenInitialMessageLoadFails: XCTestCase {

    func testTheRefreshIndicatorIsHidden() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.failLastRefresh()

        XCTAssertEqual(.hidden, context.scene.refreshIndicatorVisibility)
    }

}
