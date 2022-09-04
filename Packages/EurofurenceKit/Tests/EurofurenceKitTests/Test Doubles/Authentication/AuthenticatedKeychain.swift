import EurofurenceKit
import Foundation

class AuthenticatedKeychain: Keychain {
    
    var credential: Credential? = Credential(
        username: "Test User",
        registrationNumber: 42,
        authenticationToken: "ABC",
        tokenExpiryDate: .distantFuture
    )
    
}
