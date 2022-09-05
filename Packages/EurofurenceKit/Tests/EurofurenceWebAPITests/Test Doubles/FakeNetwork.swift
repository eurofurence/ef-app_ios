import EurofurenceWebAPI
import Foundation

class FakeNetwork: Network {
    
    private var getResponses = [URL: Result<Data, Error>]()
    private var downloadResponses = [NetworkRequest: Result<Data, Error>]()
    
    private struct NotStubbed: Error {
        var url: URL
    }
    
    enum Event: Equatable {
        case request(url: URL)
        case download(url: URL)
    }
    
    private(set) var history = [Event]()
    
    func get(contentsOf url: URL) async throws -> Data {
        history.append(.request(url: url))
        
        guard let response = getResponses[url] else {
            throw NotStubbed(url: url)
        }
        
        switch response {
        case .success(let data):
            return data
            
        case .failure(let error):
            throw error
        }
    }
    
    func download(contentsOf request: NetworkRequest, to destinationURL: URL) async throws {
        history.append(.download(url: request.url))
        
        guard let response = downloadResponses[request] else {
            throw NotStubbed(url: request.url)
        }
        
        switch response {
        case .success(let data):
            try data.write(to: destinationURL)
            
        case .failure(let error):
            throw error
        }
    }
    
    private var responses = [NetworkRequest: Result<Data, Error>]()
    func perform(request: NetworkRequest) async throws -> Data {
        history.append(.request(url: request.url))
        
        guard let response = responses[request] else {
            throw NotStubbed(url: request.url)
        }
        
        switch response {
        case .success(let data):
            return data
            
        case .failure(let error):
            throw error
        }
    }
    
    func stubDownload(of request: NetworkRequest, with result: Result<Data, Error>) {
        downloadResponses[request] = result
    }
    
    func stub(_ request: NetworkRequest, with result: Result<Data, Error>) {
        responses[request] = result
    }
    
}
