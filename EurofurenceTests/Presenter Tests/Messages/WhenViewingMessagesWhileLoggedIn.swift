@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenViewingMessagesAndLoggedIn: XCTestCase {

    var context: MessagesPresenterTestContext!

    override func setUp() {
        super.setUp()

        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
    }

    func testTheDelegateIsNotToldToResolveUserAuthentication() {
        XCTAssertFalse(context.delegate.wasToldToResolveUser)
    }

    func testTheSceneIsToldToShowRefreshIndicator() {
        XCTAssertTrue(context.scene.wasToldToShowRefreshIndicator)
    }

    func testTheSceneIsNotToldToHideRefreshIndicator() {
        XCTAssertFalse(context.scene.wasToldToHideRefreshIndicator)
    }

    func testThePrivateMessagesServiceIsToldToRefreshMessages() {
        XCTAssertTrue(context.privateMessagesService.wasToldToRefreshMessages)
    }

}
