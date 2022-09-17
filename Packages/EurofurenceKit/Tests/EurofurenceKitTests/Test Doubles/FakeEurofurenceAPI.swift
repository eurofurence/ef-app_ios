import EurofurenceKit
import EurofurenceWebAPI
import Foundation

actor FakeEurofurenceAPI: EurofurenceAPI {
    
    private struct NotStubbed<Request>: Error where Request: APIRequest {
        var request: Request
    }
    
    func stubNextSyncResponse(
        _ response: Result<SynchronizationPayload, Error>,
        for generationToken: SynchronizationPayload.GenerationToken? = nil
    ) {
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
            throw NotStubbed(request: request)
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
    
    func stub(
        _ result: Result<Void, Error>,
        forImageIdentifier imageIdentifier: String,
        lastKnownImageContentHashSHA1: String,
        downloadDestinationURL: URL
    ) {
        let expectedRequest = APIRequests.DownloadImage(
            imageIdentifier: imageIdentifier,
            lastKnownImageContentHashSHA1: lastKnownImageContentHashSHA1,
            downloadDestinationURL: downloadDestinationURL
        )
        
        stubbedResponsesByRequest[expectedRequest] = result
    }
    
    func stubLoginAttempt(_ attempt: APIRequests.Login, with result: Result<AuthenticatedUser, Error>) {
        stubbedResponsesByRequest[attempt] = result
    }
    
    func stubLogoutRequest(_ request: APIRequests.Logout, with result: Result<Void, Error>) {
        stubbedResponsesByRequest[request] = result
    }
    
    func stubMessageRequest(
        for authenticationToken: AuthenticationToken,
        with result: Result<[EurofurenceWebAPI.Message], Error>
    ) {
        stubbedResponsesByRequest[APIRequests.FetchMessages(authenticationToken: authenticationToken)] = result
    }
    
    func stubMessageReadRequest(for request: APIRequests.AcknowledgeMessage, with result: Result<Void, Error>) {
        stubbedResponsesByRequest[request] = result
    }
    
}
