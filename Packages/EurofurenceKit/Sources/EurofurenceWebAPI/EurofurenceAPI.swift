import Foundation

public protocol EurofurenceAPI {
    
    func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload
    
    func downloadImage(_ request: DownloadImage) async throws
    
    func requestAuthenticationToken(using login: Login) async throws -> AuthenticatedUser
    
    func registerPushNotificationToken(registration: RegisterPushNotificationDeviceToken) async throws
    
    func requestLogout(_ logout: Logout) async throws
    
}
