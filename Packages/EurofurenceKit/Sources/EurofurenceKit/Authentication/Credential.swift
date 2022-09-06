import EurofurenceWebAPI
import Foundation

public struct Credential: Codable, Equatable {
    
    public var username: String
    public var registrationNumber: Int
    public var authenticationToken: AuthenticationToken
    public var tokenExpiryDate: Date

    public init(
        username: String,
        registrationNumber: Int,
        authenticationToken: AuthenticationToken, 
        tokenExpiryDate: Date
    ) {
        self.username = username
        self.registrationNumber = registrationNumber
        self.authenticationToken = authenticationToken
        self.tokenExpiryDate = tokenExpiryDate
    }
    
    var isValid: Bool {
        tokenExpiryDate > Date()
    }
    
}
