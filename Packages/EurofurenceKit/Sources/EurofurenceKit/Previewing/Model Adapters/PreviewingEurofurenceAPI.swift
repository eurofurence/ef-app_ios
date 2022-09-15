import EurofurenceWebAPI

struct PreviewingEurofurenceAPI: EurofurenceAPI {
    
    var synchronizationPayload: SynchronizationPayload
    
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload {
        synchronizationPayload
    }
    
    func downloadImage(
        _ request: DownloadImage
    ) async throws {
        
    }
    
    func requestAuthenticationToken(
        using login: LoginRequest
    ) async throws -> AuthenticatedUser {
        AuthenticatedUser(
            userIdentifier: 42,
            username: "Previewing User",
            token: "Unused",
            tokenExpires: .distantFuture
        )
    }
    
    func registerPushNotificationToken(
        registration: RegisterPushNotificationDeviceToken
    ) async throws {
        
    }
    
    func requestLogout(
        _ logout: LogoutRequest
    ) async throws {
        
    }
    
    func fetchRemoteConfiguration() async -> RemoteConfiguration {
        PreviewingRemoteConfiguration()
    }
    
    func fetchMessages(for authenticationToken: AuthenticationToken) async throws -> [EurofurenceWebAPI.Message] {
        []
    }
    
    func markMessageAsRead(
        request: AcknowledgeMessageRequest
    ) async throws {
        
    }
    
}
