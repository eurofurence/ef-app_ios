import FirebaseMessaging

struct FirebasePushNotificationService: PushNotificationService {
    
    static let shared = FirebasePushNotificationService()
    private let messaging = Messaging.messaging()
    
    private init() {
        
    }
    
    var pushNotificationServiceToken: String {
        messaging.fcmToken ?? ""
    }
    
    func registerForPushNotifications(registration: PushNotificationServiceRegistration) {
        messaging.apnsToken = registration.pushNotificationDeviceTokenData
        
        for channel in registration.channels {
            messaging.subscribe(toTopic: channel)
        }
    }
    
}
