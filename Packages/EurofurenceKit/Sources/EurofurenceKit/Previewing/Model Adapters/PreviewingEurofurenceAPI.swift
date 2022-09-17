import EurofurenceWebAPI

struct PreviewingEurofurenceAPI: EurofurenceAPI {
    
    private let synchronizationPayload: SynchronizationPayload
    private let responses: [AnyHashable: Any]
    
    init(synchronizationPayload: SynchronizationPayload) {
        self.synchronizationPayload = synchronizationPayload
        
        let previewAuthenticationToken = AuthenticationToken("Preview Authentication Token")
        let authenticationUser = AuthenticatedUser(
            userIdentifier: 42,
            username: "Preview User",
            token: previewAuthenticationToken.rawValue,
            tokenExpires: .distantFuture
        )
        
        responses = [
            APIRequests.FetchLatestChanges(since: nil): synchronizationPayload,
            APIRequests.Login(registrationNumber: 42, username: "Previewe User", password: "password"): authenticationUser,
            APIRequests.FetchConfiguration(): PreviewingRemoteConfiguration(),
            APIRequests.FetchMessages(authenticationToken: previewAuthenticationToken): [Message]()
        ]
    }
    
    struct NotStubbedForPreview<Request>: Error where Request: APIRequest {
        var request: Request
    }
    
    func execute<Request>(request: Request) async throws -> Request.Output where Request : APIRequest {
        if let response = responses[request] as? Request.Output {
            return response
        } else {
            throw NotStubbedForPreview(request: request)
        }
    }
    
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload {
        synchronizationPayload
    }
    
    func downloadImage(
        _ request: APIRequests.DownloadImage
    ) async throws {
        
    }
    
    func requestAuthenticationToken(
        using login: APIRequests.Login
    ) async throws -> AuthenticatedUser {
        AuthenticatedUser(
            userIdentifier: 42,
            username: "Previewing User",
            token: "Unused",
            tokenExpires: .distantFuture
        )
    }
    
    func registerPushNotificationToken(
        registration: APIRequests.RegisterPushNotificationDeviceToken
    ) async throws {
        
    }
    
    func requestLogout(
        _ logout: APIRequests.Logout
    ) async throws {
        
    }
    
    func fetchRemoteConfiguration() async -> RemoteConfiguration {
        PreviewingRemoteConfiguration()
    }
    
    func fetchMessages(for authenticationToken: AuthenticationToken) async throws -> [EurofurenceWebAPI.Message] {
        []
    }
    
    func markMessageAsRead(
        request: APIRequests.AcknowledgeMessage
    ) async throws {
        
    }
    
}
