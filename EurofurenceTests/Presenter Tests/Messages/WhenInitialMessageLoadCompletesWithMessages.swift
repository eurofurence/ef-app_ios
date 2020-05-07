import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenInitialMessageLoadCompletesWithMessages: XCTestCase {

    func testEntersViewingMessagesState() {
        let message = StubMessage.random
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        
        XCTAssertEqual(.visible, context.scene.refreshIndicatorVisibility)
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
        
        context.privateMessagesService.succeedLastRefresh(messages: [message])
        
        XCTAssertEqual(.hidden, context.scene.refreshIndicatorVisibility)
        XCTAssertEqual(.visible, context.scene.messagesListVisibility)
        XCTAssertEqual(.hidden, context.scene.noMessagesPlaceholderVisibility)
    }

}
