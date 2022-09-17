import Foundation

public struct RegisterPushNotificationDeviceToken: Equatable, APIRequest {
    
    public typealias Output = Void
    
    public var authenticationToken: AuthenticationToken?
    public var pushNotificationDeviceToken: Data
    
    public init(authenticationToken: AuthenticationToken?, pushNotificationDeviceToken: Data) {
        self.authenticationToken = authenticationToken
        self.pushNotificationDeviceToken = pushNotificationDeviceToken
    }
    
}
