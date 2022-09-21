import EurofurenceWebAPI
import Foundation

class PreviewingEurofurenceAPI: EurofurenceAPI {
    
    private let synchronizationPayload: SynchronizationPayload
    private var responses = [AnyHashable: () async throws -> Any]()
    
    init(synchronizationPayload: SynchronizationPayload) {
        self.synchronizationPayload = synchronizationPayload
        
        let previewAuthenticationToken = AuthenticationToken("Preview Authentication Token")
        let authenticationUser = AuthenticatedUser(
            userIdentifier: 42,
            username: "Preview User",
            token: previewAuthenticationToken.rawValue,
            tokenExpires: .distantFuture
        )
        
        let loginRequest = APIRequests.Login(registrationNumber: 42, username: "Preview User", password: "password")
        respond(to: APIRequests.FetchLatestChanges(since: nil), with: { synchronizationPayload })
        respond(to: loginRequest, with: { authenticationUser })
        respond(to: APIRequests.FetchConfiguration(), with: { PreviewingRemoteConfiguration() })
        respond(to: APIRequests.FetchMessages(authenticationToken: previewAuthenticationToken), with: { [] })
    }
    
    struct NotStubbedForPreview<Request>: Error where Request: APIRequest {
        var request: Request
    }
    
    func execute<Request>(request: Request) async throws -> Request.Output where Request: APIRequest {
        if let response = responses[request] as? Request.Output {
            return response
        } else {
            throw NotStubbedForPreview(request: request)
        }
    }
    
    func url(for content: EurofurenceContent) -> URL {
        URL(fileURLWithPath: "/")
    }
    
    func respond<Request>(
        to request: Request,
        with handler: @Sendable @escaping () async throws -> Request.Output
    ) where Request: APIRequest {
        responses[request] = handler
    }
    
}
