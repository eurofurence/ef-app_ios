/// A request to login to the Eurofurence application service.
public struct Login: Hashable {
    
    /// The registration number of the user within the registration system.
    public var registrationNumber: Int
    
    /// The associated username of the user within the registration system.
    public var username: String
    
    /// The password associated with the user's registration number.
    public var password: String
    
    public init(registrationNumber: Int, username: String, password: String) {
        self.registrationNumber = registrationNumber
        self.username = username
        self.password = password
    }
    
}
