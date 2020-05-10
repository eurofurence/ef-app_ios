import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: UIApplicationDelegate

	var window: UIWindow? = UIWindow()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        prepareFrameworks()
        prepareApplication()
        prepareNotificationDelegate()
        installDebugModule()
        showApplicationWindow()
        requestRemoteNotificationsDeviceToken()

		return true
	}

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Application.storeRemoteNotificationsToken(deviceToken)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        Application.executeBackgroundFetch(completionHandler: completionHandler)
	}
    
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        Application.resume(activity: userActivity)
        return true
    }
    
    // MARK: Private

    private func prepareFrameworks() {
        FirebaseApp.configure()
    }
    
    private func prepareApplication() {
        Application.assemble()
        Theme.apply()
    }
    
    private func requestRemoteNotificationsDeviceToken() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func prepareNotificationDelegate() {
        AppNotificationDelegate.instance.prepare()
    }

    private func showApplicationWindow() {
        window?.makeKeyAndVisible()
    }

}
