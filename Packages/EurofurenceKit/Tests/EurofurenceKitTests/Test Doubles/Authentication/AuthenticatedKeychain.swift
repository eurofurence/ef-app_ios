import EurofurenceKit
import EurofurenceWebAPI
import Foundation

class AuthenticatedKeychain: Keychain {
    
    var credential: Credential? = Credential(
        username: "Test User",
        registrationNumber: 42,
        authenticationToken: AuthenticationToken("ABC"),
        tokenExpiryDate: .distantFuture
    )
    
}
