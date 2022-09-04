import Foundation

public struct Logout: Hashable {
    
    public var authenticationToken: AuthenticationToken
    public var pushNotificationDeviceToken: Data?
    
    public init(authenticationToken: AuthenticationToken, pushNotificationDeviceToken: Data?) {
        self.authenticationToken = authenticationToken
        self.pushNotificationDeviceToken = pushNotificationDeviceToken
    }
    
}
