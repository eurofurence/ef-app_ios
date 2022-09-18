import Foundation

extension APIRequests {
    
    /// A request to login to the Eurofurence application service.
    public struct Login: APIRequest {
        
        public typealias Output = AuthenticatedUser
        
        /// The registration number of the user within the registration system.
        public var registrationNumber: Int
        
        /// The associated username of the user within the registration system.
        public var username: String
        
        /// The password associated with the user's registration number.
        public var password: String
        
        public init(registrationNumber: Int, username: String, password: String) {
            self.registrationNumber = registrationNumber
            self.username = username
            self.password = password
        }
        
        public func execute(with context: APIRequestExecutionContext) async throws -> AuthenticatedUser {
            let url = context.makeURL(subpath: "Tokens/RegSys")
            let request = LoginPayload(RegNo: registrationNumber, Username: username, Password: password)
            let encoder = JSONEncoder()
            let body = try encoder.encode(request)
            
            let networkRequest = NetworkRequest(url: url, body: body, method: .post)
            let response = try await context.network.perform(request: networkRequest)
            
            let loginResponse = try context.decoder.decode(LoginResponse.self, from: response)
            
            return AuthenticatedUser(
                userIdentifier: loginResponse.Uid,
                username: loginResponse.Username,
                token: loginResponse.Token,
                tokenExpires: loginResponse.TokenValidUntil
            )
        }
        
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
        
    }
    
}
