struct FirebasePushNotificationService: PushNotificationService {
    
    static let shared = FirebasePushNotificationService()
    
    private init() {
        
    }
    
    var pushNotificationServiceToken: String = ""
    
    func registerForPushNotifications(registration: PushNotificationServiceRegistration) {
        
    }
    
}
