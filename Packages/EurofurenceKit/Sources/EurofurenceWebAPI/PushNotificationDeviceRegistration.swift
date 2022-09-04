import Foundation

public struct PushNotificationDeviceRegistration: Equatable {
    
    public var authenticationToken: String
    public var pushNotificationDeviceToken: Data
    
    public init(authenticationToken: String, pushNotificationDeviceToken: Data) {
        self.authenticationToken = authenticationToken
        self.pushNotificationDeviceToken = pushNotificationDeviceToken
    }
    
}
