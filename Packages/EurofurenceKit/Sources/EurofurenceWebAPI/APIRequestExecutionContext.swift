import Foundation

/// A parameter object used by requests during their execution.
public struct APIRequestExecutionContext {
    
    var urlComponents: URLComponents
    var conventionIdentifier: String
    var hostVersion: String
    var network: Network
    var pushNotificationService: PushNotificationService
    var decoder: JSONDecoder
    
    func makeURL(subpath: String) -> URL {
        var components = urlComponents
        components.path.append("/api/\(subpath)")
        
        guard let url = components.url else {
            fatalError("Failed to prepare URL for subpath: \(subpath)")
        }
        
        return url
    }
    
}
