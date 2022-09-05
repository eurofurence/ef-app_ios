import EurofurenceKit
import EurofurenceWebAPI
import Foundation

actor FakeEurofurenceAPI: EurofurenceAPI {
    
    private struct NotStubbed: Error { }
    
    private var nextSyncResponse: Result<SynchronizationPayload, Error>?
    
    func stubNextSyncResponse(_ response: Result<SynchronizationPayload, Error>) {
        nextSyncResponse = response
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
    
    private(set) var requestedImages = [DownloadImage]()
    private var imageDownloadResultsByIdentifier = [String: Result<Void, Error>]()
    func downloadImage(_ request: DownloadImage) async throws {
        requestedImages.append(request)
        
        if case .failure(let error) = imageDownloadResultsByIdentifier[request.imageIdentifier] {
            throw error
        }
    }
    
    private var stubbedLoginAttempts = [LoginRequest: Result<AuthenticatedUser, Error>]()
    func requestAuthenticationToken(using login: LoginRequest) async throws -> AuthenticatedUser {
        guard let response = stubbedLoginAttempts[login] else {
            throw NotStubbed()
        }

        switch response {
        case .success(let response):
            return response
            
        case .failure(let error): throw error
        }
    }
    
    private(set) var registeredDeviceTokenRequest: RegisterPushNotificationDeviceToken?
    func registerPushNotificationToken(registration: RegisterPushNotificationDeviceToken) async throws {
        registeredDeviceTokenRequest = registration
    }
    
    private var logoutResponses = [LogoutRequest: Result<Void, Error>]()
    func requestLogout(_ logout: LogoutRequest) async throws {
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
    
    func stub(_ result: Result<Void, Error>, forImageIdentifier imageIdentifier: String) {
        imageDownloadResultsByIdentifier[imageIdentifier] = result
    }
    
    func stubLoginAttempt(_ attempt: LoginRequest, with result: Result<AuthenticatedUser, Error>) {
        stubbedLoginAttempts[attempt] = result
    }
    
    func stubLogoutRequest(_ request: LogoutRequest, with result: Result<Void, Error>) {
        logoutResponses[request] = result
    }
    
    func stubMessageRequest(
        for authenticationToken: AuthenticationToken,
        with result: Result<[EurofurenceWebAPI.Message], Error>
    ) {
        messageResponses[authenticationToken] = result
    }
    
}
