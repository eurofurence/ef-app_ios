import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenInitialMessageLoadCompletesWithMessages: XCTestCase {

    func testEntersViewingMessagesState() {
        let message = StubMessage.random
        let context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
        XCTAssertFalse(context.scene.wasToldToHideRefreshIndicator)
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
        
        context.privateMessagesService.succeedLastRefresh(messages: [message])
        
        XCTAssertTrue(context.scene.wasToldToHideRefreshIndicator)
        XCTAssertTrue(context.scene.didShowMessages)
        XCTAssertFalse(context.scene.didHideMessages)
        XCTAssertTrue(context.scene.didHideNoMessagesPlaceholder)
        XCTAssertFalse(context.scene.didShowNoMessagesPlaceholder)
    }

}
