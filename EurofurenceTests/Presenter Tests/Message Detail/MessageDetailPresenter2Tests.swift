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

class FailingPrivateMessagesService: PrivateMessagesService {
    
    private let expected: MessageIdentifier
    private let response: Result<Message, Error>
    
    init(unsuccessfulForMessage expected: MessageIdentifier, providingError returnValue: Error) {
        self.expected = expected
        self.response = .failure(returnValue)
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

class ControllablePrivateMessagesService: PrivateMessagesService {
    
    func add(_ observer: PrivateMessagesObserver) {
        
    }
    
    func refreshMessages() {
        
    }
    
    private var currentCompletionHandler: ((Result<Message, Error>) -> Void)?
    func fetchMessage(identifiedBy identifier: MessageIdentifier, completionHandler: @escaping (Result<Message, Error>) -> Void) {
        currentCompletionHandler = completionHandler
    }
    
    func succeedNow(message: Message) {
        currentCompletionHandler?(.success(message))
        currentCompletionHandler = nil
    }
    
    func failNow(error: Error) {
        currentCompletionHandler?(.failure(error))
        currentCompletionHandler = nil
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
        XCTAssertEqual(message.authorName, sceneFactory.scene.capturedMessageDetailTitle)
        XCTAssertEqual(message.subject, sceneFactory.scene.viewModel?.subject)
        XCTAssertEqual(message.contents, sceneFactory.scene.viewModel?.contents)
    }
    
    struct SomeError: LocalizedError, Error {
        
        private let description: String
        
        init(description: String) {
            self.description = description
        }
        
        var errorDescription: String? {
            description
        }
        
    }
    
    func testMessageLoadFailure() {
        let messageIdentifier = MessageIdentifier.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let error = SomeError(description: .random)
        let messagesService = FailingPrivateMessagesService(unsuccessfulForMessage: messageIdentifier, providingError: error)
        let module = MessageDetail2ModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailModule(for: messageIdentifier)
        sceneFactory.scene.simulateSceneReady()
        
        XCTAssertEqual(.hidden, sceneFactory.scene.loadingIndicatorVisibility)
        XCTAssertEqual(error.localizedDescription, sceneFactory.scene.errorViewModel?.errorDescription)
    }
    
    func testRetryingAfterFailure() {
        let messageIdentifier = MessageIdentifier.random
        let sceneFactory = StubMessageDetailSceneFactory()
        let error = SomeError(description: .random)
        let messagesService = ControllablePrivateMessagesService()
        let module = MessageDetail2ModuleBuilder(messagesService: messagesService).with(sceneFactory).build()
        _ = module.makeMessageDetailModule(for: messageIdentifier)
        sceneFactory.scene.simulateSceneReady()
        messagesService.failNow(error: SomeError(description: ""))
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
