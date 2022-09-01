import Foundation

public struct CIDSensitiveEurofurenceAPI: EurofurenceAPI {
    
    private let network: Network
    private let decoder: JSONDecoder
    
    public static func api() -> EurofurenceAPI {
        CIDSensitiveEurofurenceAPI(network: URLSessionNetwork.shared)
    }
    
    private init(network: Network) {
        self.network = network
        decoder = EurofurenceAPIDecoder()
    }
    
    public func executeSyncRequest(lastUpdateTime: Date?) async throws -> SynchronizationPayload {
        let sinceToken: String = {
            if let lastUpdateTime = lastUpdateTime {
                let formattedTime = EurofurenceISO8601DateFormatter.instance.string(from: lastUpdateTime)
                return "?since=\(formattedTime)"
            } else {
                return ""
            }
        }()
        
        let urlString = "https://app.eurofurence.org/EF26/api/Sync\(sinceToken)"
        guard let url = URL(string: urlString) else { fatalError() }
        
        let data = try await network.get(contentsOf: url)
        let response = try decoder.decode(SynchronizationPayload.self, from: data)
        
        return response
    }
    
}
