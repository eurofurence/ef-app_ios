@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenUserSelectsMessage_DirectorShould: XCTestCase {

    var context: ApplicationDirectorTestBuilder.Context!
    var message: StubMessage!

    override func setUp() {
        super.setUp()

        message = .random
        context = ApplicationDirectorTestBuilder().build()
        context.navigateToTabController()
        context.newsModule.simulatePrivateMessagesDisplayRequested()
        context.messages.simulateMessagePresentationRequested(message)
    }

    func testBuildMessageDetailModuleUsingMessage() {
        XCTAssertEqual(message.identifier, context.messageDetailModule.capturedMessage)
    }

    func testPushMessageDetailModuleOntoMessagesNavigationController() {
        let navigationController = context.messages.stubInterface.navigationController
        XCTAssertEqual(context.messageDetailModule.stubInterface, navigationController?.topViewController)
    }

}
