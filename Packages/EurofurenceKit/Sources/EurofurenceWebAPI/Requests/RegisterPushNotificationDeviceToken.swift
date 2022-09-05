import Foundation

public struct RegisterPushNotificationDeviceToken: Equatable {
    
    public var authenticationToken: AuthenticationToken?
    public var pushNotificationDeviceToken: Data
    
    public init(authenticationToken: AuthenticationToken?, pushNotificationDeviceToken: Data) {
        self.authenticationToken = authenticationToken
        self.pushNotificationDeviceToken = pushNotificationDeviceToken
    }
    
}
