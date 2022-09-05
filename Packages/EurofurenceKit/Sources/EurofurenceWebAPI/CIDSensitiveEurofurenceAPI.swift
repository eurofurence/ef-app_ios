import Foundation

public struct CIDSensitiveEurofurenceAPI: EurofurenceAPI {
    
    private let network: Network
    private let decoder: JSONDecoder
    
    public static func api() -> EurofurenceAPI {
        CIDSensitiveEurofurenceAPI(network: URLSessionNetwork.shared)
    }
    
    init(network: Network) {
        self.network = network
        decoder = EurofurenceAPIDecoder()
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
        
        let urlString = "https://app.eurofurence.org/EF26/api/Sync\(sinceToken)"
        guard let url = URL(string: urlString) else { fatalError() }
        
        let data = try await network.get(contentsOf: url)
        let response = try decoder.decode(SynchronizationPayload.self, from: data)
        
        return response
    }
    
    public func downloadImage(_ request: DownloadImage) async throws {
        let id = request.imageIdentifier
        let hash = request.lastKnownImageContentHashSHA1
        let downloadURLString = "https://app.eurofurence.org/EF26/api/Images/\(id)/Content/with-hash:\(hash)"
        guard let downloadURL = URL(string: downloadURLString) else { return }
        
        if FileManager.default.fileExists(atPath: request.downloadDestinationURL.path) {
            try FileManager.default.removeItem(at: request.downloadDestinationURL)
        }
        
        try await network.download(contentsOf: downloadURL, to: request.downloadDestinationURL)
    }
    
    public func requestAuthenticationToken(using login: Login) async throws -> AuthenticatedUser {
        let urlString = "https://app.eurofurence.org/EF26/api/Token/SysReg"
        guard let url = URL(string: urlString) else { fatalError() }
        
        let request = LoginRequest(RegNo: login.registrationNumber, Username: login.username, Password: login.password)
        let encoder = JSONEncoder()
        let body = try encoder.encode(request)
        
        let networkRequest = NetworkRequest(url: url, body: body, method: .post)
        let response = try await network.perform(request: networkRequest)
        
        let loginResponse = try decoder.decode(LoginResponse.self, from: response)
        
        return AuthenticatedUser(
            userIdentifier: loginResponse.Uid,
            username: loginResponse.Username,
            token: loginResponse.Token,
            tokenExpires: loginResponse.TokenValidUntil
        )
    }
    
    public func registerPushNotificationToken(registration: RegisterPushNotificationDeviceToken) async throws {
        
    }
    
    public func requestLogout(_ logout: Logout) async throws {
        
    }
    
    struct LoginRequest: Encodable {
        var RegNo: Int
        var Username: String
        var Password: String
    }
    
    struct LoginResponse: Decodable {
        var Uid: Int
        var Username: String
        var Token: String
        var TokenValidUntil: Date
    }
    
}
