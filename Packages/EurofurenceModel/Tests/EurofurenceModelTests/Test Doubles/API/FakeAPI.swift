import EurofurenceModel
import Foundation

class FakeAPI: API {
    
    private var feedbackRequests: [EventFeedbackRequest: (Bool) -> Void] = [:]
    
    func submitEventFeedback(_ request: EventFeedbackRequest, completionHandler: @escaping (Bool) -> Void) {
        feedbackRequests[request] = completionHandler
    }
    
    func simulateSuccessfulFeedbackResponse(for request: EventFeedbackRequest) {
        guard let handler = feedbackRequests[request] else { return }
        
        handler(true)
        feedbackRequests[request] = nil
    }
    
    func simulateUnsuccessfulFeedbackResponse(for request: EventFeedbackRequest) {
        guard let handler = feedbackRequests[request] else { return }
        
        handler(false)
        feedbackRequests[request] = nil
    }

    private(set) var capturedLoginRequest: LoginRequest?
    private var loginHandler: ((LoginResponse?) -> Void)?
    func performLogin(request: LoginRequest, completionHandler: @escaping (LoginResponse?) -> Void) {
        capturedLoginRequest = request
        loginHandler = completionHandler
    }

    private(set) var wasToldToLoadPrivateMessages = false
    private(set) var privateMessagesLoadCount = 0
    private(set) var capturedAuthToken: String?
    private var messagesHandler: (([MessageCharacteristics]?) -> Void)?
    func loadPrivateMessages(authorizationToken: String,
                             completionHandler: @escaping ([MessageCharacteristics]?) -> Void) {
        wasToldToLoadPrivateMessages = true
        privateMessagesLoadCount += 1
        capturedAuthToken = authorizationToken
        self.messagesHandler = completionHandler
    }

    private(set) var messageIdentifierMarkedAsRead: String?
    private(set) var capturedAuthTokenForMarkingMessageAsRead: String?
    func markMessageWithIdentifierAsRead(_ identifier: String, authorizationToken: String) {
        messageIdentifierMarkedAsRead = identifier
        capturedAuthTokenForMarkingMessageAsRead = authorizationToken
    }
    
    var requestedFullStoreRefresh: Bool {
        return capturedLastSyncTime == nil
    }

    fileprivate var completionHandler: ((ModelCharacteristics?) -> Void)?
    private(set) var capturedLastSyncTime: Date?
    private(set) var didBeginSync = false
    func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void) {
        didBeginSync = true
        capturedLastSyncTime = lastSyncTime
        self.completionHandler = completionHandler
    }
    
    private struct DownloadRequest: Hashable {
        var identifier: String
        var contentHashSha1: String
    }
    
    private var stubbedResponses = [DownloadRequest: Data]()

    private(set) var downloadedImageIdentifiers = [String]()
    func fetchImage(identifier: String, contentHashSha1: String, completionHandler: @escaping (Data?) -> Void) {
        downloadedImageIdentifiers.append(identifier)
        
        let data = "\(identifier)_\(contentHashSha1)".data(using: .utf8)
        let request = DownloadRequest(identifier: identifier, contentHashSha1: contentHashSha1)
        stubbedResponses[request] = data
        
        completionHandler(data)
    }

}

extension FakeAPI {
    
    func stubbedImage(for identifier: String?, availableImages: [ImageCharacteristics]) -> Data? {
        return stubbedResponses.first(where: { $0.key.identifier == identifier })?.value
    }

    func simulateSuccessfulSync(_ response: ModelCharacteristics) {
        completionHandler?(response)
    }

    func simulateUnsuccessfulSync() {
        completionHandler?(nil)
    }

    func simulateLoginResponse(_ response: LoginResponse) {
        loginHandler?(response)
    }

    func simulateLoginFailure() {
        loginHandler?(nil)
    }

    func simulateMessagesResponse(response: [MessageCharacteristics] = []) {
        messagesHandler?(response)
    }

    func simulateMessagesFailure() {
        messagesHandler?(nil)
    }

}

class SlowFakeImageAPI: FakeAPI {

    fileprivate var pendingFetches = [() -> Void]()

    var numberOfPendingFetches: Int {
        return pendingFetches.count
    }

    override func fetchImage(
        identifier: String,
        contentHashSha1: String, 
        completionHandler: @escaping (Data?) -> Void
    ) {
        pendingFetches.append {
            super.fetchImage(
                identifier: identifier,
                contentHashSha1: contentHashSha1,
                completionHandler: completionHandler
            )
        }
    }

}

extension SlowFakeImageAPI {

    func resolvePendingFetches() {
        pendingFetches.forEach({ $0() })
        pendingFetches.removeAll()
    }

    func resolveNextFetch() {
        guard pendingFetches.isEmpty == false else { return }

        let next = pendingFetches.remove(at: 0)
        next()
    }

}

class OnlyToldToRefreshOnceMockAPI: FakeAPI {
    
    private var refreshCount = 0
    var toldToRefreshOnlyOnce: Bool {
        return refreshCount == 1
    }
    
    override func fetchLatestData(lastSyncTime: Date?, completionHandler: @escaping (ModelCharacteristics?) -> Void) {
        refreshCount += 1
        super.fetchLatestData(lastSyncTime: lastSyncTime, completionHandler: completionHandler)
    }
    
}
