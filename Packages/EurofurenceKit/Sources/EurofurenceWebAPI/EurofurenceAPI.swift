import Foundation

public protocol APIRequest: Hashable {
    
    associatedtype Output
    
}

public enum APIRequests { }

extension APIRequests {
    
    public struct FetchLatestChanges: APIRequest {
        
        public typealias Output = SynchronizationPayload
        
        let previousChangeToken: SynchronizationPayload.GenerationToken?
        
        public init(since previousChangeToken: SynchronizationPayload.GenerationToken?) {
            self.previousChangeToken = previousChangeToken
        }
        
    }
    
    public struct FetchMessages: APIRequest {
        
        public typealias Output = [Message]
        
        let authenticationToken: AuthenticationToken
        
        public init(authenticationToken: AuthenticationToken) {
            self.authenticationToken = authenticationToken
        }
        
    }
    
    public struct FetchConfiguration: APIRequest {
        
        public typealias Output = RemoteConfiguration
        
        public init() {
            
        }
        
    }
    
}

public protocol EurofurenceAPI {
    
    func execute<Request>(request: Request) async throws -> Request.Output where Request: APIRequest
    
//    func fetchChanges(
//        since previousChangeToken: SynchronizationPayload.GenerationToken?
//    ) async throws -> SynchronizationPayload
//    
//    func downloadImage(_ request: DownloadImage) async throws
//    
//    func requestAuthenticationToken(using login: LoginRequest) async throws -> AuthenticatedUser
//    
//    func registerPushNotificationToken(registration: RegisterPushNotificationDeviceToken) async throws
//    
//    func requestLogout(_ logout: LogoutRequest) async throws
//    
//    func fetchMessages(for authenticationToken: AuthenticationToken) async throws -> [Message]
//    
//    func fetchRemoteConfiguration() async -> RemoteConfiguration
//
//    func markMessageAsRead(request: AcknowledgeMessageRequest) async throws

}
