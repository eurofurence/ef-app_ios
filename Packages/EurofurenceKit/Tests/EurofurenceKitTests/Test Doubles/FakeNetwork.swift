import EurofurenceKit
import Foundation

class FakeNetwork: Network {
    
    private var getResponses = [URL: Data]()
    
    private struct NotStubbed: Error {
        var url: URL
    }
    
    func get(contentsOf url: URL) async throws -> Data {
        if let response = getResponses[url] {
            return response
        } else {
            throw NotStubbed(url: url)
        }
    }
    
    func stub(url: URL, with data: Data) {
        getResponses[url] = data
    }
    
}
