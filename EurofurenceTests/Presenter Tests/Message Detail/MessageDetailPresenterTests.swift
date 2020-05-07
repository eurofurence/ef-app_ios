import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class MessageDetailPresenterTests: XCTestCase {
    
    func testLoadingMessage() {
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = CapturingPrivateMessagesService()
        let module = MessageDetailModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailModule(for: .random)
        
        XCTAssertEqual(.unset, sceneFactory.scene.loadingIndicatorVisibility)
        
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertEqual(.visible, sceneFactory.scene.loadingIndicatorVisibility)
    }
    
    func testMessageLoaded() {
        let messageIdentifier = MessageIdentifier.random
        let message = StubMessage.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = SuccessfulPrivateMessagesService(successfulForMessage: messageIdentifier, providingMessage: message)
        let module = MessageDetailModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailModule(for: messageIdentifier)
        
        XCTAssertFalse(message.markedRead)
        
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertTrue(message.markedRead)
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
        XCTAssertEqual(message.authorName, sceneFactory.scene.capturedMessageDetailTitle)
        XCTAssertEqual(message.subject, sceneFactory.scene.viewModel?.subject)
        XCTAssertEqual(message.contents, sceneFactory.scene.viewModel?.contents)
    }
    
    func testMessageLoadFailure() throws {
        let messageIdentifier = MessageIdentifier.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let error = PrivateMessageError.noMessageFound
        let messagesService = FailingPrivateMessagesService(unsuccessfulForMessage: messageIdentifier, providingError: error)
        let module = MessageDetailModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailModule(for: messageIdentifier)
        sceneFactory.scene.simulateSceneReady()
        
        let boundErrorDescription = try XCTUnwrap(sceneFactory.scene.errorViewModel?.errorDescription)
        
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
        XCTAssertTrue(error.errorDescription == boundErrorDescription)
    }
    
    func testRetryingAfterFailure() {
        let messageIdentifier = MessageIdentifier.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = ControllablePrivateMessagesService()
        let module = MessageDetailModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailModule(for: messageIdentifier)
        sceneFactory.scene.simulateSceneReady()
        messagesService.failNow(error: .loadingMessagesFailed)
        sceneFactory.scene.errorViewModel?.retry()
        
        XCTAssertEqual(.visible, sceneFactory.scene.loadingIndicatorVisibility)
        
        let message = StubMessage.random
        messagesService.succeedNow(message: message)
        
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
        XCTAssertEqual(message.authorName, sceneFactory.scene.capturedMessageDetailTitle)
        XCTAssertEqual(message.subject, sceneFactory.scene.viewModel?.subject)
        XCTAssertEqual(message.contents, sceneFactory.scene.viewModel?.contents)
    }

}
