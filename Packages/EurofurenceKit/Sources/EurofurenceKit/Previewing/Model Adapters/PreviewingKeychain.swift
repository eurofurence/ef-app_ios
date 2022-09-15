import EurofurenceWebAPI

class PreviewingKeychain: Keychain {
    
    init(state: EurofurenceModel.AuthenticationState) {
        switch state {
        case .authenticated:
            credential = Credential(
                username: "Preview User",
                registrationNumber: 42,
                authenticationToken: AuthenticationToken("Unused"),
                tokenExpiryDate: .distantFuture
            )
            
        case .unauthenticated:
            credential = nil
        }
    }
    
    var credential: Credential?
    
}
