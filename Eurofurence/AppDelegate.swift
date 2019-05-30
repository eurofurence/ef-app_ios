import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: UIApplicationDelegate

	var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        prepareFrameworks()
        prepareApplicationStack()
        prepareNotificationDelegate()
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
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return ApplicationStack.resumeInteraction(userActivity.interaction?.intent)
    }
    
    // MARK: Private

    private func prepareFrameworks() {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()
    }
    
    private func prepareApplicationStack() {
        ApplicationStack.assemble()
        Theme.apply()
        ReviewPromptController.initialize()
    }
    
    private func prepareNotificationDelegate() {
        AppNotificationDelegate.instance.prepare()
    }

    private func showApplicationWindow() {
        window?.makeKeyAndVisible()
    }

}
