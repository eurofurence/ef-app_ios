import Foundation

public struct AuthenticatedUser {
        
    public var userIdentifier: Int
    public var username: String
    public var token: String
    public var tokenExpires: Date
    
    public init(userIdentifier: Int, username: String, token: String, tokenExpires: Date) {
        self.userIdentifier = userIdentifier
        self.username = username
        self.token = token
        self.tokenExpires = tokenExpires
    }
    
}
