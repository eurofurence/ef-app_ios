import Combine
import EurofurenceWebAPI

public class LoginParameters: ObservableObject {
    
    @Published public var registrationNumber: Int? {
        didSet {
            validateLogin()
        }
    }
    
    @Published public var username: String {
        didSet {
           validateLogin()
        }
    }
    
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
    }
    
    private func validateLogin() {
        canLogin = registrationNumber != nil && username.isEmpty == false && password.isEmpty == false
    }
    
    var login: Login? {
        guard let registrationNumber = registrationNumber, canLogin else {
            return nil
        }

        return Login(registrationNumber: registrationNumber, username: username, password: password)
    }
    
}
