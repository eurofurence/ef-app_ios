import EurofurenceApplication
import UserNotifications

class AppNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    // MARK: UNUserNotificationCenterDelegate
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        Application.openNotification(
            response.notification.request.content.userInfo,
            completionHandler: completionHandler
        )
    }
    
    // MARK: Setup
    
    static let instance = AppNotificationDelegate()
    
    override private init() {
        
    }
    
    func prepare() {
        prepareNotificationHandler()
        requestNotificationPermissions()
    }
    
    private func prepareNotificationHandler() {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermissions()
    }
    
    private func requestNotificationPermissions() {
        var authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        if #available(iOS 15, *) {
            authorizationOptions.insert(.timeSensitive)
        }
        
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { (_, error) in
            if let error = error {
                print("Failed to register for notifications with error: \(error)")
            }
        }
    }
    
}
