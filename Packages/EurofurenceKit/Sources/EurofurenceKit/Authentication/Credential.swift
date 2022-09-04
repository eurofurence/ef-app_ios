import Foundation

public struct Credential: Codable {
    
    public var username: String
    public var registrationNumber: Int
    public var authenticationToken: String
    public var tokenExpiryDate: Date

    public init(username: String, registrationNumber: Int, authenticationToken: String, tokenExpiryDate: Date) {
        self.username = username
        self.registrationNumber = registrationNumber
        self.authenticationToken = authenticationToken
        self.tokenExpiryDate = tokenExpiryDate
    }
    
}
