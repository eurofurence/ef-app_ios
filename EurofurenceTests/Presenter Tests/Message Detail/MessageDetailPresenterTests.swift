import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class SuccessfulPrivateMessagesService: PrivateMessagesService {
    
    private let expected: MessageIdentifier
    private let response: Result<Message, PrivateMessageError>
    
    init(successfulForMessage expected: MessageIdentifier, providingMessage returnValue: Message) {
        self.expected = expected
        self.response = .success(returnValue)
    }
    
    func add(_ observer: PrivateMessagesObserver) {
        
    }
    
    func refreshMessages() {
        
    }
    
    func fetchMessage(identifiedBy identifier: MessageIdentifier, completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void) {
        if identifier == expected {
            completionHandler(response)
        }
    }
    
}

class FailingPrivateMessagesService: PrivateMessagesService {
    
    private let expected: MessageIdentifier
    private let response: Result<Message, PrivateMessageError>
    
    init(unsuccessfulForMessage expected: MessageIdentifier, providingError returnValue: PrivateMessageError) {
        self.expected = expected
        self.response = .failure(returnValue)
    }
    
    func add(_ observer: PrivateMessagesObserver) {
        
    }
    
    func refreshMessages() {
        
    }
    
    func fetchMessage(identifiedBy identifier: MessageIdentifier, completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void) {
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
    
    private var currentCompletionHandler: ((Result<Message, PrivateMessageError>) -> Void)?
    func fetchMessage(identifiedBy identifier: MessageIdentifier, completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void) {
        currentCompletionHandler = completionHandler
    }
    
    func succeedNow(message: Message) {
        currentCompletionHandler?(.success(message))
        currentCompletionHandler = nil
    }
    
    func failNow(error: PrivateMessageError) {
        currentCompletionHandler?(.failure(error))
        currentCompletionHandler = nil
    }
    
}

struct StubMessageDetailSceneFactory: MessageDetailSceneFactory {

    let scene = CapturingMessageDetailScene()
    func makeMessageDetailScene() -> UIViewController & MessageDetailScene {
        return scene
    }

}

class CapturingMessageDetailScene: UIViewController, MessageDetailScene {

    var delegate: MessageDetailSceneDelegate?
    
    private(set) var loadingIndicatorVisibility: VisibilityState = .unset
    private(set) var viewModel: MessageDetailViewModel?
    private(set) var errorViewModel: MessageDetailErrorViewModel?
    
    func showLoadingIndicator() {
        loadingIndicatorVisibility = .visible
    }
    
    func hideLoadingIndicator() {
        loadingIndicatorVisibility = .hidden
    }
    
    func showMessage(viewModel: MessageDetailViewModel) {
        self.viewModel = viewModel
    }
    
    func showError(viewModel: MessageDetailErrorViewModel) {
        errorViewModel = viewModel
    }

    private(set) var capturedMessageDetailTitle: String?
    func setMessageDetailTitle(_ title: String) {
        capturedMessageDetailTitle = title
    }

    private(set) var numberOfMessageComponentsAdded = 0
    private(set) var capturedMessageBinder: MessageComponentBinder?
    func addMessageComponent(with binder: MessageComponentBinder) {
        numberOfMessageComponentsAdded += 1
        capturedMessageBinder = binder
    }
    
    func simulateSceneReady() {
        delegate?.messageDetailSceneDidLoad()
    }
    
}

class MessageDetailPresenter2Tests: XCTestCase {
    
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
