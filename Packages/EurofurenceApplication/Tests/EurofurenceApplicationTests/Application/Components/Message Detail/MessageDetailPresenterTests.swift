import EurofurenceApplication
import EurofurenceModel
import XCTComponentBase
import XCTest
import XCTEurofurenceModel

class MessageDetailPresenterTests: XCTestCase {
    
    func testLoadingMessage() {
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = CapturingPrivateMessagesService()
        let module = MessageDetailComponentBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailComponent(for: .random)
        
        XCTAssertEqual(.unset, sceneFactory.scene.loadingIndicatorVisibility)
        
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertEqual(.visible, sceneFactory.scene.loadingIndicatorVisibility)
    }
    
    func testMessageLoaded() {
        let messageIdentifier = MessageIdentifier.random
        let message = StubMessage.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = SuccessfulPrivateMessagesService(
            successfulForMessage: messageIdentifier,
            providingMessage: message
        )
        
        let markdownRenderer = StubMarkdownRenderer()
        let module = MessageDetailComponentBuilder(messagesService: messagesService)
            .with(sceneFactory)
            .with(markdownRenderer)
            .build()
        
        _ = module.makeMessageDetailComponent(for: messageIdentifier)
        
        XCTAssertFalse(message.markedRead)
        
        sceneFactory.scene.simulateSceneReady()
        
        let expectedContents = markdownRenderer.stubbedContents(for: message.contents)
        
        XCTAssertTrue(message.markedRead)
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
        XCTAssertEqual(message.authorName, sceneFactory.scene.capturedMessageDetailTitle)
        XCTAssertEqual(message.subject, sceneFactory.scene.viewModel?.subject)
        XCTAssertEqual(expectedContents, sceneFactory.scene.viewModel?.contents)
    }
    
    func testMessageLoadFailure() throws {
        let messageIdentifier = MessageIdentifier.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let error = PrivateMessageError.noMessageFound
        let messagesService = FailingPrivateMessagesService(
            unsuccessfulForMessage: messageIdentifier,
            providingError: error
        )
        
        let module = MessageDetailComponentBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailComponent(for: messageIdentifier)
        sceneFactory.scene.simulateSceneReady()
        
        let boundErrorDescription = try XCTUnwrap(sceneFactory.scene.errorViewModel?.errorDescription)
        
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
        XCTAssertTrue(error.errorDescription == boundErrorDescription)
    }
    
    func testRetryingAfterFailure() {
        let messageIdentifier = MessageIdentifier.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = ControllablePrivateMessagesService()
        let markdownRenderer = StubMarkdownRenderer()
        
        let module = MessageDetailComponentBuilder(messagesService: messagesService)
            .with(sceneFactory)
            .with(markdownRenderer)
            .build()
        
        _ = module.makeMessageDetailComponent(for: messageIdentifier)
        sceneFactory.scene.simulateSceneReady()
        messagesService.failNow(error: .loadingMessagesFailed)
        sceneFactory.scene.errorViewModel?.retry()
        
        XCTAssertEqual(.visible, sceneFactory.scene.loadingIndicatorVisibility)
        
        let message = StubMessage.random
        messagesService.succeedNow(message: message)
        
        let expectedContents = markdownRenderer.stubbedContents(for: message.contents)
        
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
        XCTAssertEqual(message.authorName, sceneFactory.scene.capturedMessageDetailTitle)
        XCTAssertEqual(message.subject, sceneFactory.scene.viewModel?.subject)
        XCTAssertEqual(expectedContents, sceneFactory.scene.viewModel?.contents)
    }

}
