import Foundation

/// A parameter object used by requests during their execution.
public struct APIRequestExecutionContext {
    
    var conventionIdentifier: String
    var hostVersion: String
    var network: Network
    var pushNotificationService: PushNotificationService
    var decoder: JSONDecoder
    
    func makeURL(subpath: String) -> URL {
        let baseURL = "https://app.eurofurence.org/\(conventionIdentifier)"
        guard let url = URL(string: "\(baseURL)/api/\(subpath)") else {
            fatalError("Failed to make URL")
        }
        
        return url
    }
    
}
