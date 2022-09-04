import Foundation

public struct Logout: Hashable {
    
    public var authenticationToken: String
    public var pushNotificationDeviceToken: Data?
    
    public init(authenticationToken: String, pushNotificationDeviceToken: Data?) {
        self.authenticationToken = authenticationToken
        self.pushNotificationDeviceToken = pushNotificationDeviceToken
    }
    
}
