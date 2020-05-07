@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenRefreshingMessages: XCTestCase {

    var context: MessagesPresenterTestContext!

    override func setUp() {
        super.setUp()

        context = MessagesPresenterTestContext.makeTestCaseForAuthenticatedUser()
        context.scene.delegate?.messagesSceneWillAppear()
        context.scene.delegate?.messagesSceneDidPerformRefreshAction()
    }

    func testThePrivateMessagesServiceIsToldToReload() {
        XCTAssertEqual(2, context.privateMessagesService.refreshMessagesCount)
    }

    func testTheSceneIsToldToHideTheRefreshIndicatorWhenRefreshFinishes() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertEqual(.hidden, context.scene.refreshIndicatorVisibility)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsToldToHideTheMessagesList() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertEqual(.hidden, context.scene.messagesListVisibility)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsNotToldToShowTheMessagesList() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertEqual(.hidden, context.scene.messagesListVisibility)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsToldToShowTheMessagesList() {
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage.random])
        XCTAssertEqual(.visible, context.scene.messagesListVisibility)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsToldShowTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertEqual(.visible, context.scene.noMessagesPlaceholderVisibility)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsNotToldShowTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage.random])
        XCTAssertEqual(.hidden, context.scene.noMessagesPlaceholderVisibility)
    }

    func testWhenRefreshActionCompletesWithMessageTheSceneIsToldHideTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh(messages: [StubMessage.random])
        XCTAssertEqual(.hidden, context.scene.noMessagesPlaceholderVisibility)
    }

    func testWhenRefreshActionCompletesWithNoMessagesTheSceneIsNotToldHideTheNoMessagesPlaceholder() {
        context.privateMessagesService.succeedLastRefresh()
        XCTAssertEqual(.visible, context.scene.noMessagesPlaceholderVisibility)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsToldToBindWithTheNumberOfMessages() {
        let messages = [StubMessage].random
        context.privateMessagesService.succeedLastRefresh(messages: messages)

        XCTAssertEqual(messages.count, context.scene.boundMessageCount)
    }

    func testWhenRefreshActionCompletesWithMessagesTheSceneIsToldToBindWithTheMessage() {
        let message = StubMessage.random
        context.privateMessagesService.succeedLastRefresh(messages: [message])
        let component = CapturingMessageItemScene()
        context.scene.capturedMessageItemBinder?.bind(component, toMessageAt: IndexPath(row: 0, section: 0))

        XCTAssertEqual(message.subject, component.capturedSubject)
    }

}
