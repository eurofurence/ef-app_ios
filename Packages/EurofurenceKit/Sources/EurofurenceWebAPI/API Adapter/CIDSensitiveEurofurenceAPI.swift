import Foundation

public struct CIDSensitiveEurofurenceAPI: EurofurenceAPI {
    
    private let configuration: Configuration
    private let decoder: JSONDecoder
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        decoder = EurofurenceAPIDecoder()
    }
    
    public func execute<Request>(request: Request) async throws -> Request.Output where Request: APIRequest {
        let context = APIRequestExecutionContext(
            urlComponents: configuration.urlComponents,
            conventionIdentifier: configuration.conventionIdentifier,
            hostVersion: configuration.hostVersion,
            network: configuration.network,
            pushNotificationService: configuration.pushNotificationService,
            decoder: decoder
        )
        
        return try await request.execute(with: context)
    }
    
    public func url(for content: EurofurenceContent) -> URL {
        let subPath: String
        switch content {
        case .event(let id):
            subPath = "/Web/Events/\(id)"
        }
        
        var components = configuration.urlComponents
        components.path.append(subPath)
        
        guard let url = components.url else {
            fatalError("Failed to prepare URL for content: \(content)")
        }
        
        return url
    }
    
}

// MARK: - Configuration

extension CIDSensitiveEurofurenceAPI {
    
    public struct Configuration {
                
        var conventionIdentifier: String
        var hostVersion: String
        var network: Network
        var pushNotificationService: PushNotificationService
        var urlComponents: URLComponents
        
        public init(conventionIdentifier: String, hostVersion: String) {
            self.init(
                conventionIdentifier: conventionIdentifier,
                hostVersion: hostVersion,
                network: URLSessionNetwork.shared,
                pushNotificationService: FirebasePushNotificationService.shared
            )
        }
        
        internal init(
            conventionIdentifier: String,
            hostVersion: String,
            network: Network,
            pushNotificationService: PushNotificationService
        ) {
            self.conventionIdentifier = conventionIdentifier
            self.hostVersion = hostVersion
            self.network = network
            self.pushNotificationService = pushNotificationService
            
            urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "app.eurofurence.org"
            urlComponents.path = "/\(conventionIdentifier)"
        }
        
    }
    
}

// MARK: - Request Payloads

extension CIDSensitiveEurofurenceAPI {
    
    private struct RegisterDeviceTokenRequest: Encodable {
        var DeviceId: String
        var Topics: [String]
    }
    
}
