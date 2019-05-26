import UIKit
import Firebase
import UserNotifications
import EurofurenceModel

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow? = UIWindow()
    private var director: ApplicationDirector?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareFrameworks()
        prepareNotificationHandler()
        installDebugModule()
        prepareDirector()
        showApplicationWindow()

		return true
	}

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ApplicationStack.instance.services.notifications.storeRemoteNotificationsToken(deviceToken)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ApplicationStack.instance.notificationFetchResultAdapter.handleRemoteNotification(userInfo, completionHandler: completionHandler)
	}

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        director?.openNotification(response.notification.request.content.userInfo, completionHandler: completionHandler)
    }

    private func prepareFrameworks() {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()
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

    private func prepareDirector() {
        let services = ApplicationStack.instance.services
        let director = DirectorBuilder(linkLookupService: services.contentLinks, notificationHandling: services.notifications).build()
        services.contentLinks.setExternalContentHandler(director)
        self.director = director
    }

    private func showApplicationWindow() {
        window?.makeKeyAndVisible()
    }

}
