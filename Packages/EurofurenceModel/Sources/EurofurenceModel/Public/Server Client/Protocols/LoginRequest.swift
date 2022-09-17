import Foundation

public struct APIRequests.LoginRequest {
    
    public var regNo: Int
    public var username: String
    public var password: String
    
    public init(regNo: Int, username: String, password: String) {
        self.regNo = regNo
        self.username = username
        self.password = password
    }
    
}
