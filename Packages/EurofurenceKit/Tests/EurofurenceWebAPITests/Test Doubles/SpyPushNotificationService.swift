import EurofurenceWebAPI

class SpyPushNotificationService: PushNotificationService {
    
    var pushNotificationServiceToken: String = "Device Identifier"
    
    private(set) var registration: PushNotificationServiceRegistration?
    func registerForPushNotifications(registration: PushNotificationServiceRegistration) {
        self.registration = registration
    }
    
}
