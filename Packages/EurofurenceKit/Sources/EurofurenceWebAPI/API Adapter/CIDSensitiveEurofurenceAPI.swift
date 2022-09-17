import Foundation

public struct CIDSensitiveEurofurenceAPI: EurofurenceAPI {
    
    private let configuration: Configuration
    private let decoder: JSONDecoder
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        decoder = EurofurenceAPIDecoder()
    }
    
    struct NotImplemented: Error { }
    public func execute<Request>(request: Request) async throws -> Request.Output where Request : APIRequest {
        
        throw NotImplemented()
    }
    
    private func makeURL(subpath: String) -> URL {
        let baseURL = "https://app.eurofurence.org/\(configuration.conventionIdentifier)"
        guard let url = URL(string: "\(baseURL)/api/\(subpath)") else {
            fatalError("Failed to make URL")
        }
        
        return url
    }
    
    public func fetchChanges(
        since previousChangeToken: SynchronizationPayload.GenerationToken?
    ) async throws -> SynchronizationPayload {
        let sinceToken: String = {
            if let lastUpdateTime = previousChangeToken?.lastSyncTime {
                let formattedTime = EurofurenceISO8601DateFormatter.instance.string(from: lastUpdateTime)
                return "?since=\(formattedTime)"
            } else {
                return ""
            }
        }()
        
        let url = makeURL(subpath: "Sync\(sinceToken)")
        let request = NetworkRequest(url: url, method: .get)
        
        let data = try await configuration.network.perform(request: request)
        let response = try decoder.decode(SynchronizationPayload.self, from: data)
        
        return response
    }
    
    public func downloadImage(_ request: DownloadImage) async throws {
        let id = request.imageIdentifier
        let hash = request.lastKnownImageContentHashSHA1
        let downloadURL = makeURL(subpath: "Images/\(id)/Content/with-hash:\(hash)")
        let downloadRequest = NetworkRequest(url: downloadURL, method: .get)
        
        if FileManager.default.fileExists(atPath: request.downloadDestinationURL.path) {
            try FileManager.default.removeItem(at: request.downloadDestinationURL)
        }
        
        try await configuration.network.download(contentsOf: downloadRequest, to: request.downloadDestinationURL)
    }
    
    public func requestAuthenticationToken(using login: LoginRequest) async throws -> AuthenticatedUser {
        let url = makeURL(subpath: "Tokens/RegSys")
        let request = LoginPayload(RegNo: login.registrationNumber, Username: login.username, Password: login.password)
        let encoder = JSONEncoder()
        let body = try encoder.encode(request)
        
        let networkRequest = NetworkRequest(url: url, body: body, method: .post)
        let response = try await configuration.network.perform(request: networkRequest)
        
        let loginResponse = try decoder.decode(LoginResponse.self, from: response)
        
        return AuthenticatedUser(
            userIdentifier: loginResponse.Uid,
            username: loginResponse.Username,
            token: loginResponse.Token,
            tokenExpires: loginResponse.TokenValidUntil
        )
    }
    
    public func registerPushNotificationToken(registration: RegisterPushNotificationDeviceToken) async throws {
        try await associatePushNotificationToken(
            registration.pushNotificationDeviceToken,
            withUserAuthenticationToken: registration.authenticationToken
        )
    }
    
    public func requestLogout(_ logout: LogoutRequest) async throws {
        // Logging out = disassociate the authentication token with the push token.
        try await associatePushNotificationToken(
            logout.pushNotificationDeviceToken,
            withUserAuthenticationToken: nil
        )
    }
    
    public func fetchMessages(for authenticationToken: AuthenticationToken) async throws -> [Message] {
        let url = makeURL(subpath: "Communication/PrivateMessages")
        let request = NetworkRequest(url: url, method: .get, headers: [
            "Authorization": "Bearer \(authenticationToken.stringValue)"
        ])
        
        let responseData = try await configuration.network.perform(request: request)
        let messages = try decoder.decode([Message].self, from: responseData)
        
        return messages
    }
    
    public func fetchRemoteConfiguration() async -> RemoteConfiguration {
        FirebaseRemoteConfiguration.shared
    }
    
    public func markMessageAsRead(request: AcknowledgeMessageRequest) async throws {
        let url = makeURL(subpath: "Communication/PrivateMessages/\(request.messageIdentifier)/Read")
        guard let bodyForSwagger = "true".data(using: .utf8) else {
            fatalError("Could not produce a data object from the Swagger body")
        }
        
        let networkRequest = NetworkRequest(url: url, body: bodyForSwagger, method: .post, headers: [
            "Authorization": "Bearer \(request.authenticationToken.stringValue)"
        ])
        
        try await configuration.network.perform(request: networkRequest)
    }
    
    private func associatePushNotificationToken(
        _ pushNotificationData: Data?,
        withUserAuthenticationToken authenticationToken: AuthenticationToken?
    ) async throws {
        let conventionIdentifier = configuration.conventionIdentifier
        let hostVersion = configuration.hostVersion
        
        let pushNotificationServiceRegistration = PushNotificationServiceRegistration(
            pushNotificationDeviceTokenData: pushNotificationData,
            channels: ["\(conventionIdentifier)", "\(conventionIdentifier)-ios"]
        )
        
        configuration.pushNotificationService.registerForPushNotifications(
            registration: pushNotificationServiceRegistration
        )
        
        let registerDeviceTokenRequest = RegisterDeviceTokenRequest(
            DeviceId: configuration.pushNotificationService.pushNotificationServiceToken,
            Topics: ["iOS", "version-\(hostVersion)", "cid-\(conventionIdentifier)"]
        )
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(registerDeviceTokenRequest)
        
        let registrationURL = makeURL(subpath: "PushNotifications/FcmDeviceRegistration")
        
        var headers = NetworkRequest.Headers()
        if let authenticationToken = authenticationToken {
            headers["Authorization"] = "Bearer \(authenticationToken.stringValue)"
        }
        
        let networkRequest = NetworkRequest(url: registrationURL, body: body, method: .post, headers: headers)
        try await configuration.network.perform(request: networkRequest)
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
    
    private struct LoginPayload: Encodable {
        var RegNo: Int
        var Username: String
        var Password: String
    }
    
    private struct LoginResponse: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case Uid
            case Username
            case Token
            case TokenValidUntil
        }
        
        var Uid: Int
        var Username: String
        var Token: String
        var TokenValidUntil: Date
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            // UIDs look like: RegSys:EF26:<ID>
            let uidString = try container.decode(String.self, forKey: .Uid)
            let splitIdentifier = uidString.components(separatedBy: ":")
            
            if let stringIdentifier = splitIdentifier.last, let registrationIdentifier = Int(stringIdentifier) {
                Uid = registrationIdentifier
            } else {
                throw CouldNotParseRegistrationIdentifier(uid: uidString)
            }
            
            Username = try container.decode(String.self, forKey: .Username)
            Token = try container.decode(String.self, forKey: .Token)
            TokenValidUntil = try container.decode(Date.self, forKey: .TokenValidUntil)
        }
        
        private struct CouldNotParseRegistrationIdentifier: Error {
            var uid: String
        }
        
    }
    
    private struct RegisterDeviceTokenRequest: Encodable {
        var DeviceId: String
        var Topics: [String]
    }
    
}
