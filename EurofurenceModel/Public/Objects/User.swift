import Foundation

public struct User {

    public var registrationNumber: Int
    public var username: String

    public init(registrationNumber: Int, username: String) {
        self.registrationNumber = registrationNumber
        self.username = username
    }

}
