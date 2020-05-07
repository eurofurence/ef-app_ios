import Eurofurence
import EurofurenceModel
import XCTest

class WhenInitialMessagesLoadCompletesWithNoMessages: XCTestCase {

    func testEntersViewingPlaceholderState() {
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.privateMessagesService.succeedLastRefresh()
        
        XCTAssertEqual(.hidden, context.scene.refreshIndicatorVisibility)
        XCTAssertEqual(.hidden, context.scene.messagesListVisibility)
        XCTAssertEqual(.visible, context.scene.noMessagesPlaceholderVisibility)
    }

}
