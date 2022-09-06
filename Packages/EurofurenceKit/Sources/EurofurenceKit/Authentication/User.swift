import EurofurenceWebAPI

/// An authenticated user within the application.
public struct User {
    
    /// The unique registration number associated with the user.
    public var registrationNumber: Int
    
    /// The name given by the user from the registration system.
    public var name: String
    
    init(authenticatedUser: AuthenticatedUser) {
        registrationNumber = authenticatedUser.userIdentifier
        name = authenticatedUser.username
    }
    
    init(credential: Credential) {
        registrationNumber = credential.registrationNumber
        name = credential.username
    }
    
}
