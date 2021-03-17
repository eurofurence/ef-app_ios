import EurofurenceModel

public class SuccessfulPrivateMessagesService: PrivateMessagesService {
    
    private let expected: MessageIdentifier
    private let response: Result<Message, PrivateMessageError>
    
    public init(successfulForMessage expected: MessageIdentifier, providingMessage returnValue: Message) {
        self.expected = expected
        self.response = .success(returnValue)
    }
    
    public func add(_ observer: PrivateMessagesObserver) {
        
    }
    
    public func removeObserver(_ observer: PrivateMessagesObserver) {
        
    }
    
    public func refreshMessages() {
        
    }
    
    public func fetchMessage(
        identifiedBy identifier: MessageIdentifier,
        completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void
    ) {
        if identifier == expected {
            completionHandler(response)
        }
    }
    
}

public class FailingPrivateMessagesService: PrivateMessagesService {
    
    private let expected: MessageIdentifier
    private let response: Result<Message, PrivateMessageError>
    
    public init(unsuccessfulForMessage expected: MessageIdentifier, providingError returnValue: PrivateMessageError) {
        self.expected = expected
        self.response = .failure(returnValue)
    }
    
    public func add(_ observer: PrivateMessagesObserver) {
        
    }
    
    public func removeObserver(_ observer: PrivateMessagesObserver) {
        
    }
    
    public func refreshMessages() {
        
    }
    
    public func fetchMessage(
        identifiedBy identifier: MessageIdentifier,
        completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void
    ) {
        if identifier == expected {
            completionHandler(response)
        }
    }
    
}

public class ControllablePrivateMessagesService: PrivateMessagesService {
    
    public init() {
        
    }
    
    public func add(_ observer: PrivateMessagesObserver) {
        
    }
    
    public func removeObserver(_ observer: PrivateMessagesObserver) {
        
    }
    
    public func refreshMessages() {
        
    }
    
    private var currentCompletionHandler: ((Result<Message, PrivateMessageError>) -> Void)?
    public func fetchMessage(
        identifiedBy identifier: MessageIdentifier,
        completionHandler: @escaping (Result<Message, PrivateMessageError>) -> Void
    ) {
        currentCompletionHandler = completionHandler
    }
    
    public func succeedNow(message: Message) {
        currentCompletionHandler?(.success(message))
        currentCompletionHandler = nil
    }
    
    public func failNow(error: PrivateMessageError) {
        currentCompletionHandler?(.failure(error))
        currentCompletionHandler = nil
    }
    
}
