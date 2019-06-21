import EurofurenceModel

extension Credential {
    
    static var randomValidCredential: Credential {
        return Credential(username: .random,
                          registrationNumber: .random,
                          authenticationToken: .random,
                          tokenExpiryDate: .distantFuture)
    }
    
}
