import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareFrameworks()
        prepareApplicationStack()
        prepareNotificationHandler()
        installDebugModule()
        showApplicationWindow()

		return true
	}

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ApplicationStack.storeRemoteNotificationsToken(deviceToken)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ApplicationStack.handleRemoteNotification(userInfo, completionHandler: completionHandler)
	}

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        ApplicationStack.openNotification(response.notification.request.content.userInfo, completionHandler: completionHandler)
    }

    private func prepareFrameworks() {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()
    }
    
    private func prepareApplicationStack() {
        ApplicationStack.assemble()
        Theme.apply()
        ReviewPromptController.initialize()
    }
    
    private func prepareNotificationHandler() {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermissions()
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, error) in
            if let error = error {
                print("Failed to register for notifications with error: \(error)")
            }
        }
    }

    private func showApplicationWindow() {
        window?.makeKeyAndVisible()
    }

}
