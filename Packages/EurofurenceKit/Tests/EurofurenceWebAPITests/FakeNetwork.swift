import EurofurenceWebAPI
import Foundation

class FakeNetwork: Network {
    
    private var getResponses = [URL: Result<Data, Error>]()
    private var downloadResponses = [URL: Result<Data, Error>]()
    
    private struct NotStubbed: Error {
        var url: URL
    }
    
    enum Event: Equatable {
        case get(url: URL)
        case download(url: URL)
    }
    
    private(set) var history = [Event]()
    
    func get(contentsOf url: URL) async throws -> Data {
        history.append(.get(url: url))
        
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
    
    func download(contentsOf url: URL, to destinationURL: URL) async throws {
        history.append(.download(url: url))
        
        guard let response = downloadResponses[url] else {
            throw NotStubbed(url: url)
        }
        
        switch response {
        case .success(let data):
            try data.write(to: destinationURL)
            
        case .failure(let error):
            throw error
        }
    }
    
    func stub(url: URL, with result: Result<Data, Error>) {
        getResponses[url] = result
    }
    
    func stubDownload(of url: URL, with result: Result<Data, Error>) {
        downloadResponses[url] = result
    }
    
}
