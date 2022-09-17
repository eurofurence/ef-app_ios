import EurofurenceKit
import EurofurenceWebAPI
import Foundation

actor FakeEurofurenceAPI: EurofurenceAPI {
    
    private struct NotStubbed: Error { }
    
    private var nextSyncResponse: Result<SynchronizationPayload, Error>?
    
    func stubNextSyncResponse(
        _ response: Result<SynchronizationPayload, Error>,
        for generationToken: SynchronizationPayload.GenerationToken? = nil
    ) {
        nextSyncResponse = response
        stubbedResponsesByRequest[APIRequests.FetchLatestChanges(since: generationToken)] = response
    }
    
    private var stubbedResponsesByRequest = [AnyHashable: Any]()
    let remoteConfiguration = FakeRemoteConfiguration()
    
    init() {
        stubbedResponsesByRequest[APIRequests.FetchConfiguration()] = Result<RemoteConfiguration, Error>.success(remoteConfiguration)
    }
    
    private var executedRequests = [Any]()
    func execute<Request>(request: Request) async throws -> Request.Output where Request : APIRequest {
        executedRequests.append(request)
        
        guard let response = stubbedResponsesByRequest[request] as? Result<Request.Output, Error> else {
            throw NotStubbed()
        }
        
        switch response {
        case .success(let success):
            return success
            
        case .failure(let failure):
            throw failure
        }
    }
    
    func executedRequests<T>(ofType: T.Type) -> [T] where T: APIRequest {
        executedRequests.compactMap({ $0 as? T })
    }
    
    func executed<T>(request: T) -> Bool where T: APIRequest {
        let requests: [T] = executedRequests(ofType: T.self)
        return requests.contains(request)
    }
    
    private(set) var lastChangeToken: SynchronizationPayload.GenerationToken?
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload {
        lastChangeToken = previousChangeToken
        
        guard let nextSyncResponse = nextSyncResponse else {
            throw NotStubbed()
        }

        switch nextSyncResponse {
        case .success(let payload):
            return payload
            
        case .failure(let error):
            throw error
        }
    }
    
    private var imageDownloadResultsByIdentifier = [String: Result<Void, Error>]()
    func downloadImage(_ request: APIRequests.DownloadImage) async throws {
        if case .failure(let error) = imageDownloadResultsByIdentifier[request.imageIdentifier] {
            throw error
        }
    }
    
    private var stubbedLoginAttempts = [APIRequests.LoginRequest: Result<AuthenticatedUser, Error>]()
    func requestAuthenticationToken(using login: APIRequests.LoginRequest) async throws -> AuthenticatedUser {
        guard let response = stubbedLoginAttempts[login] else {
            throw NotStubbed()
        }

        switch response {
        case .success(let response):
            return response
            
        case .failure(let error): throw error
        }
    }
    
    private(set) var registeredDeviceTokenRequest: APIRequests.RegisterPushNotificationDeviceToken?
    func registerPushNotificationToken(registration: APIRequests.RegisterPushNotificationDeviceToken) async throws {
        registeredDeviceTokenRequest = registration
    }
    
    private var logoutResponses = [APIRequests.LogoutRequest: Result<Void, Error>]()
    func requestLogout(_ logout: APIRequests.LogoutRequest) async throws {
        guard let response = logoutResponses[logout] else {
            throw NotStubbed()
        }
        
        switch response {
        case .success:
            return
            
        case .failure(let error):
            throw error
        }
    }
    
    private var messageResponses = [AuthenticationToken: Result<[EurofurenceWebAPI.Message], Error>]()
    func fetchMessages(for authenticationToken: AuthenticationToken) async throws -> [EurofurenceWebAPI.Message] {
        guard let response = messageResponses[authenticationToken] else {
            return []
        }
        
        switch response {
        case .success(let messages):
            return messages
            
        case .failure(let error):
            throw error
        }
    }
    
    
    func fetchRemoteConfiguration() async -> RemoteConfiguration {
        remoteConfiguration
    }
    
    private(set) var markedMessageReadIdentifiers = [String]()
    private var messageReadRequestResponses = [APIRequests.AcknowledgeMessageRequest: Result<Void, Error>]()
    func markMessageAsRead(request: APIRequests.AcknowledgeMessageRequest) async throws {
        markedMessageReadIdentifiers.append(request.messageIdentifier)
        
        guard let response = messageReadRequestResponses[request] else {
            throw NotStubbed()
        }
        
        switch response {
        case .success:
            return
            
        case .failure(let error):
            throw error
        }
    }
    
    func stub(
        _ result: Result<Void, Error>,
        forImageIdentifier imageIdentifier: String,
        lastKnownImageContentHashSHA1: String,
        downloadDestinationURL: URL
    ) {
        imageDownloadResultsByIdentifier[imageIdentifier] = result
        
        let expectedRequest = APIRequests.DownloadImage(
            imageIdentifier: imageIdentifier,
            lastKnownImageContentHashSHA1: lastKnownImageContentHashSHA1,
            downloadDestinationURL: downloadDestinationURL
        )
        
        stubbedResponsesByRequest[expectedRequest] = result
    }
    
    func stubLoginAttempt(_ attempt: APIRequests.LoginRequest, with result: Result<AuthenticatedUser, Error>) {
        stubbedLoginAttempts[attempt] = result
        stubbedResponsesByRequest[attempt] = result
    }
    
    func stubLogoutRequest(_ request: APIRequests.LogoutRequest, with result: Result<Void, Error>) {
        logoutResponses[request] = result
        stubbedResponsesByRequest[request] = result
    }
    
    func stubMessageRequest(
        for authenticationToken: AuthenticationToken,
        with result: Result<[EurofurenceWebAPI.Message], Error>
    ) {
        messageResponses[authenticationToken] = result
        stubbedResponsesByRequest[APIRequests.FetchMessages(authenticationToken: authenticationToken)] = result
    }
    
    func stubMessageReadRequest(for request: APIRequests.AcknowledgeMessageRequest, with result: Result<Void, Error>) {
        messageReadRequestResponses[request] = result
        stubbedResponsesByRequest[request] = result
    }
    
}
