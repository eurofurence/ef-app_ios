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
            conventionIdentifier: configuration.conventionIdentifier,
            hostVersion: configuration.hostVersion,
            network: configuration.network,
            pushNotificationService: configuration.pushNotificationService,
            decoder: decoder
        )
        
        return try await request.execute(with: context)
    }
    
}

// MARK: - Configuration

extension CIDSensitiveEurofurenceAPI {
    
    public struct Configuration {
                
        var conventionIdentifier: String
        var hostVersion: String
        var network: Network
        var pushNotificationService: PushNotificationService
        
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
