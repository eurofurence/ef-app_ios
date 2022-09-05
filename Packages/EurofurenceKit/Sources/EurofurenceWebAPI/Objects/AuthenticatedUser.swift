import Foundation

public struct AuthenticatedUser: Equatable {
        
    public var userIdentifier: Int
    public var username: String
    public var token: AuthenticationToken
    public var tokenExpires: Date
    
    public init(userIdentifier: Int, username: String, token: String, tokenExpires: Date) {
        self.userIdentifier = userIdentifier
        self.username = username
        self.token = AuthenticationToken(token)
        self.tokenExpires = tokenExpires
    }
    
}
