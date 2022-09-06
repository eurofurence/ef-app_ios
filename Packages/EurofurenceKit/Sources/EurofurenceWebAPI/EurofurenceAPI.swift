import Foundation

public protocol EurofurenceAPI {
    
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload
    
    func downloadImage(_ request: DownloadImage) async throws
    
    func requestAuthenticationToken(using login: LoginRequest) async throws -> AuthenticatedUser
    
    func registerPushNotificationToken(registration: RegisterPushNotificationDeviceToken) async throws
    
    func requestLogout(_ logout: LogoutRequest) async throws
    
    func fetchMessages(for authenticationToken: AuthenticationToken) async throws -> [Message]
    
    func fetchRemoteConfiguration() async -> RemoteConfiguration

    func markMessageAsRead(identifiedBy identifier: String) async throws

}
