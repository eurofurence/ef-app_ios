import EurofurenceKit
import Foundation

class FakeNetwork: Network {
    
    private var getResponses = [URL: Result<Data, Error>]()
    
    private struct NotStubbed: Error {
        var url: URL
    }
    
    func get(contentsOf url: URL) async throws -> Data {
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
    
    func stub(url: URL, with result: Result<Data, Error>) {
        getResponses[url] = result
    }
    
}
