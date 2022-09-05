import ComponentBase
import EurofurenceApplication
import EurofurenceKit
import FirebaseCore
import UIKit

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: UIApplicationDelegate

	public var window: UIWindow?
    
    private let model = EurofurenceModel()

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        prepareFrameworks()
        prepareApplication()
        prepareNotificationDelegate()
        requestRemoteNotificationsDeviceToken()

		return true
	}
    
    public func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let userDefaults = UserDefaults.standard
        let isSwiftUIEnabled = userDefaults.bool(forKey: "EFSwiftUIAppVariantEnabled")
        let sceneConfigurationName = isSwiftUIEnabled ? "Principal SwiftUI Window Scene" : "Principal Window Scene"
        
        return UISceneConfiguration(name: sceneConfigurationName, sessionRole: connectingSceneSession.role)
    }

    public func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Task(priority: .utility) {
            await model.registerRemoteNotificationDeviceTokenData(deviceToken)
        }
        
        Application.storeRemoteNotificationsToken(deviceToken)
    }

    public func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        Application.executeBackgroundFetch(completionHandler: completionHandler)
	}
    
    public func application(
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
        let dependencies = Application.Dependencies(
            viewEventIntentDonor: DonateFromAppEventIntentDonor(),
            viewDealerIntentDonor: DonateFromAppDealerIntentDonor(),
            appIcons: ApplicationTargetAppIconRepository()
        )
        
        Application.assemble(dependencies: dependencies)
        
        Theme.global.apply()
    }
    
    private func requestRemoteNotificationsDeviceToken() {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    private func prepareNotificationDelegate() {
        AppNotificationDelegate.instance.prepare()
    }

}
