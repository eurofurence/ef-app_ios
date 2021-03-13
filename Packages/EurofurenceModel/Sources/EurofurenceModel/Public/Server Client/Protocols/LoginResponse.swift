import Foundation

public struct LoginResponse {

    public var userIdentifier: String
    public var username: String
    public var token: String
    public var tokenValidUntil: Date

    public init(userIdentifier: String, username: String, token: String, tokenValidUntil: Date) {
        self.userIdentifier = userIdentifier
        self.username = username
        self.token = token
        self.tokenValidUntil = tokenValidUntil
    }

}
