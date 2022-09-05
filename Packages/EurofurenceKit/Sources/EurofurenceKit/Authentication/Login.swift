import Combine
import EurofurenceWebAPI

/// A collection of parameters required to login to the Eurofurence application.
public class Login: ObservableObject {
    
    /// The registration number of the attendee. Must be present to permit login.
    @Published public var registrationNumber: Int? {
        didSet {
            validateLogin()
        }
    }
    
    /// The attendees username. Must be a non-empty string to permit login.
    @Published public var username: String {
        didSet {
           validateLogin()
        }
    }
    
    /// The attendees password. Must be a non-empty string to permit login.
    @Published public var password: String {
        didSet {
            validateLogin()
        }
    }
    
    @Published public private(set) var canLogin: Bool = false
    
    public init(registrationNumber: Int? = nil, username: String = "", password: String = "") {
        self.registrationNumber = registrationNumber
        self.username = username
        self.password = password
        validateLogin()
    }
    
    private func validateLogin() {
        canLogin = registrationNumber != nil && username.isEmpty == false && password.isEmpty == false
    }
    
    var request: LoginRequest? {
        guard let registrationNumber = registrationNumber, canLogin else {
            return nil
        }

        return LoginRequest(registrationNumber: registrationNumber, username: username, password: password)
    }
    
}
