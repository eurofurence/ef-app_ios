import Foundation

public struct LoginArguments {

    public var registrationNumber: Int
    public var username: String
    public var password: String

    public init(registrationNumber: Int, username: String, password: String) {
        self.registrationNumber = registrationNumber
        self.username = username
        self.password = password
    }

}
