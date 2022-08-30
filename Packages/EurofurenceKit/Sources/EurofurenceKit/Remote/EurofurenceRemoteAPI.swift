import Foundation

struct EurofurenceRemoteAPI {
    
    private let network: Network
    private let decoder: JSONDecoder
    
    init(network: Network) {
        self.network = network
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(EurofurenceISO8601DateFormatter.instance)
    }
    
    func executeSyncRequest() async throws -> RemoteSyncResponse {
        let url = URL(string: "https://app.eurofurence.org/EF26/api/Sync").unsafelyUnwrapped
        let data = try await network.get(contentsOf: url)
        let response = try decoder.decode(RemoteSyncResponse.self, from: data)
        
        return response
    }
    
}
