import EurofurenceKit
import EurofurenceWebAPI
import Foundation

class ExpiredCredentialKeychain: Keychain {
    
    var credential: Credential? = Credential(
        username: "Test User",
        registrationNumber: 42,
        authenticationToken: AuthenticationToken("ABC"),
        tokenExpiryDate: .distantPast
    )
    
}
