import Foundation

public protocol PushNotificationService {
    
    var pushNotificationServiceToken: String { get }
    
    func registerForPushNotifications(registration: PushNotificationServiceRegistration)
    
}

public struct PushNotificationServiceRegistration: Equatable {
    
    var pushNotificationDeviceTokenData: Data?
    var channels: Set<String>
    
    public init(pushNotificationDeviceTokenData: Data?, channels: Set<String>) {
        self.pushNotificationDeviceTokenData = pushNotificationDeviceTokenData
        self.channels = channels
    }
    
}
