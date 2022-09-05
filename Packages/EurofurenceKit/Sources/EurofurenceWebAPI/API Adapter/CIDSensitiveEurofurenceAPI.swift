import Foundation

public struct CIDSensitiveEurofurenceAPI: EurofurenceAPI {
    
    private let configuration: Configuration
    private let decoder: JSONDecoder
    
    public init(configuration: Configuration) {
        self.configuration = configuration
        decoder = EurofurenceAPIDecoder()
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
    
    public func requestAuthenticationToken(using login: Login) async throws -> AuthenticatedUser {
        let url = makeURL(subpath: "Token/SysReg")
        let request = LoginRequest(RegNo: login.registrationNumber, Username: login.username, Password: login.password)
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
        let conventionIdentifier = configuration.conventionIdentifier
        let hostVersion = configuration.hostVersion
        
        let pushNotificationServiceRegistration = PushNotificationServiceRegistration(
            pushNotificationDeviceTokenData: registration.pushNotificationDeviceToken,
            channels: ["\(conventionIdentifier)", "\(conventionIdentifier)-ios"]
        )
        
        configuration.pushNotificationService.registerForPushNotifications(registration: pushNotificationServiceRegistration)
        
        let registerDeviceTokenRequest = RegisterDeviceTokenRequest(
            DeviceId: configuration.pushNotificationService.pushNotificationServiceToken,
            Topics: ["iOS", "version-\(hostVersion)", "cid-\(conventionIdentifier)"]
        )
        
        let encoder = JSONEncoder()
        let body = try encoder.encode(registerDeviceTokenRequest)
        
        let registrationURL = makeURL(subpath: "PushNotifications/FcmDeviceRegistration")
        
        var headers = NetworkRequest.Headers()
        if let authenticationToken = registration.authenticationToken {
            headers["Authorization"] = "Bearer \(authenticationToken.stringValue)"
        }
        
        let networkRequest = NetworkRequest(url: registrationURL, body: body, method: .post, headers: headers)
        try await configuration.network.perform(request: networkRequest)
    }
    
    public func requestLogout(_ logout: Logout) async throws {
        
    }
    
    private struct LoginRequest: Encodable {
        var RegNo: Int
        var Username: String
        var Password: String
    }
    
    private struct LoginResponse: Decodable {
        var Uid: Int
        var Username: String
        var Token: String
        var TokenValidUntil: Date
    }
    
    private struct RegisterDeviceTokenRequest: Encodable {
        var DeviceId: String
        var Topics: [String]
    }
    
}

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
