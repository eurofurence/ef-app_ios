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
    
    private(set) var requestedImages = [DownloadImageRequest]()
    private var imageDownloadResultsByIdentifier = [String: Result<Void, Error>]()
    func downloadImage(_ request: DownloadImageRequest) async throws {
        requestedImages.append(request)
        
        if case .failure(let error) = imageDownloadResultsByIdentifier[request.imageIdentifier] {
            throw error
        }
    }
    
    private var stubbedLoginAttempts = [Login: Result<AuthenticatedUser, Error>]()
    func requestAuthenticationToken(using login: Login) async throws -> AuthenticatedUser {
        guard let response = stubbedLoginAttempts[login] else {
            throw NotStubbed()
        }

        switch response {
        case .success(let response):
            return response
            
        case .failure(let error): throw error
        }
    }
    
    private(set) var registeredDeviceTokenRequest: PushNotificationDeviceRegistration?
    func registerPushNotificationToken(registration: PushNotificationDeviceRegistration) async throws {
        registeredDeviceTokenRequest = registration
    }
    
    private var logoutResponses = [Logout: Result<Void, Error>]()
    func requestLogout(_ logout: Logout) async throws {
        guard let response = logoutResponses[logout] else {
            throw NotStubbed()
        }
        
        switch response {
        case .success(()):
            return
            
        case .failure(let error):
            throw error
        }
    }
    
    func stub(_ result: Result<Void, Error>, forImageIdentifier imageIdentifier: String) {
        imageDownloadResultsByIdentifier[imageIdentifier] = result
    }
    
    func stubLoginAttempt(_ attempt: Login, with result: Result<AuthenticatedUser, Error>) {
        stubbedLoginAttempts[attempt] = result
    }
    
    func stubLogoutRequest(_ request: Logout, with result: Result<Void, Error>) {
        logoutResponses[request] = result
    }
    
}
