import EurofurenceKit
import EurofurenceWebAPI
import Foundation

class FakeEurofurenceAPI: EurofurenceAPI {
    
    private var stubbedResponsesByRequest = [AnyHashable: Any]()
    let remoteConfiguration = FakeRemoteConfiguration()
    
    init() {
        let successfulRemoteConfigurationResponse = Result<RemoteConfiguration, Error>.success(remoteConfiguration)
        stubbedResponsesByRequest[APIRequests.FetchConfiguration()] = successfulRemoteConfigurationResponse
    }
    
    func stub<Request>(request: Request, with response: Result<Request.Output, Error>) where Request: APIRequest {
        stubbedResponsesByRequest[request] = response
    }
    
    private struct NotStubbed<Request>: Error where Request: APIRequest {
        var request: Request
    }
    
    private var executedRequests = [Any]()
    private let lock = NSRecursiveLock()
    func execute<Request>(request: Request) async throws -> Request.Output where Request: APIRequest {
        lock.lock()
        
        defer {
            lock.unlock()
        }
        
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
    
    private var stubbedURLs = [EurofurenceContent: URL]()
    func stub(_ url: URL, forContent content: EurofurenceContent) {
        stubbedURLs[content] = url
    }
    
    func url(for content: EurofurenceContent) -> URL {
        stubbedURLs[content, default: synthesizeDefaultURL(for: content)]
    }
    
    private func synthesizeDefaultURL(for content: EurofurenceContent) -> URL {
        switch content {
        case .event(let id):
            return URL(string: "https://app.eurofurence.org/Event/\(id)").unsafelyUnwrapped
        }
    }
    
    func executedRequests<T>(ofType: T.Type) -> [T] where T: APIRequest {
        executedRequests.compactMap({ $0 as? T })
    }
    
    func executed<T>(request: T) -> Bool where T: APIRequest {
        let requests: [T] = executedRequests(ofType: T.self)
        return requests.contains(request)
    }
    
}
