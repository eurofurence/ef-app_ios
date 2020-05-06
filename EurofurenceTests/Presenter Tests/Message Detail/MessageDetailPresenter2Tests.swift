import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class SuccessfulPrivateMessagesService: PrivateMessagesService {
    
    private let expected: MessageIdentifier
    private let response: Result<Message, Error>
    
    init(successfulForMessage expected: MessageIdentifier, providingMessage returnValue: Message) {
        self.expected = expected
        self.response = .success(returnValue)
    }
    
    func add(_ observer: PrivateMessagesObserver) {
        
    }
    
    func refreshMessages() {
        
    }
    
    func fetchMessage(identifiedBy identifier: MessageIdentifier, completionHandler: @escaping (Result<Message, Error>) -> Void) {
        if identifier == expected {
            completionHandler(response)
        }
    }
    
}

class MessageDetailPresenter2Tests: XCTestCase {
    
    func testLoadingMessage() {
        let sceneFactory = StubMessageDetailSceneFactory()
        let messagesService = CapturingPrivateMessagesService()
        let module = MessageDetail2ModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
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
        let module = MessageDetail2ModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailModule(for: messageIdentifier)
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
    }
    
    func testMessageLoadFailure() {
        
    }
    
    func testRetryingAfterFailure() {
        
    }

}
