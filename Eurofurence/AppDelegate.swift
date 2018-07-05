//
//  AppDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift
import EVReflection
import Firebase
import Whisper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private func makePantone330UShadowImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { (context) in
            UIColor.pantone330U.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

	var window: UIWindow?
    lazy var app = EurofurenceApplication.shared
	lazy var targetRouter: TargetRouter = StoryboardTargetRouter(window: self.window!)
	lazy var notificationRouter: NotificationRouter = StoryboardNotificationRouter(window: self.window!, targetRouter: self.targetRouter)
    private var director: ApplicationDirector?

    private func applyDirectorBasedTheme() {
        let whiteTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.white]
        let pantone330UColourImage = makePantone330UShadowImage()

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.barTintColor = .pantone330U
        navigationBarAppearance.titleTextAttributes = whiteTextAttributes
        navigationBarAppearance.shadowImage = pantone330UColourImage

        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = .pantone330U
        tabBarAppearance.tintColor = .white
        tabBarAppearance.backgroundImage = pantone330UColourImage
        tabBarAppearance.shadowImage = pantone330UColourImage

        let buttonInsideTableView = UIButton.appearance(whenContainedInInstancesOf: [UITableView.self])
        buttonInsideTableView.setTitleColor(.pantone330U, for: .normal)

        let tableViewProxy = UITableView.appearance()
        tableViewProxy.sectionIndexColor = .pantone330U

        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes(whiteTextAttributes, for: .normal)

        let buttonsInsideNavigationBarAppearance = UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        buttonsInsideNavigationBarAppearance.tintColor = .white

        let navigationBarExtensionAppearance = NavigationBarViewExtensionContainer.appearance()
        navigationBarExtensionAppearance.backgroundColor = .pantone330U

        let labelsInsideNavigationBarExtensionAppearance = UILabel.appearance(whenContainedInInstancesOf: [NavigationBarViewExtensionContainer.self])
        labelsInsideNavigationBarExtensionAppearance.textColor = .white

        let searchBarAppearance = UISearchBar.appearance()
        searchBarAppearance.barTintColor = .pantone330U
        searchBarAppearance.isTranslucent = false

        let textFieldAppearance = UITextField.appearance()
        textFieldAppearance.tintColor = .pantone330U

        let buttonsInsideSearchBarAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        buttonsInsideSearchBarAppearance.setTitleTextAttributes(whiteTextAttributes, for: .normal)
    }

    private func installDebugModuleIntoWindow() {
        guard let window = window else { return }

        let complicatedGesture = UITapGestureRecognizer(target: self, action: #selector(showDebugMenu))
        complicatedGesture.numberOfTouchesRequired = 2
        complicatedGesture.numberOfTapsRequired = 5
        window.addGestureRecognizer(complicatedGesture)
    }

    @objc private func showDebugMenu(_ sender: UIGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Debug", bundle: .main)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }

        let host = UINavigationController(rootViewController: viewController)
        host.modalPresentationStyle = .formSheet
        window?.rootViewController?.present(host, animated: true)
    }

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()
        installDebugModuleIntoWindow()

		try! ContextResolver.container.bootstrap()
		try! ServiceResolver.container.bootstrap()
		try! ViewModelResolver.container.bootstrap()

		PrintOptions.Active = .None

        DataStoreRefreshController.shared.add(ApplicationActivityIndicatorRefreshDelegate())

        if UserSettings.UseDirector.currentValueOrDefault() {
            applyDirectorBasedTheme()

            let director = DirectorBuilder().build()
            self.director = director
            EurofurenceApplication.shared.setExternalContentHandler(director)
        } else {
            PresentationTier.assemble(window: window!)
        }

		// App was launched from local or remote notification
		if let notification = launchOptions?[.localNotification] as? UILocalNotification {
			notificationRouter.showLocalNotificationTarget(for: notification, doWaitForDataStore: true)
		} else if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable: Any] {
			notificationRouter.showRemoteNotificationTarget(for: userInfo, doWaitForDataStore: true)
		}

		return true
	}

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        app.storeRemoteNotificationsToken(deviceToken)
        ApplicationPushPermissionsRequesting.shared.handlePushRegistrationSuccess()
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        ApplicationPushPermissionsRequesting.shared.handlePushRegistrationFailure()
	}

	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		if application.applicationState == .inactive {
			notificationRouter.showLocalNotificationTarget(for: notification, doWaitForDataStore: false)
		} else if application.applicationState == .active {
			notificationRouter.showLocalNotification(for: notification)
		}
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		if let contentTypeString = userInfo[NotificationUserInfoKey.ContentType.rawValue] as? String,
			let contentType = NotificationContentType(rawValue: contentTypeString) {

			switch contentType {
			case .Sync: // should have content-available == 1; triggers sync
				// TODO: Inform the user about changes to his favourite events
				DataStoreRefreshController.shared.add(NotificationSyncDataStoreRefreshDelegate(completionHandler: completionHandler))
				DataStoreRefreshController.shared.refreshStore(withDelta: true)

			case .Announcement: // Contains announcement title and message
				if application.applicationState == .inactive {
					// Application was launched from tapping the notification -> forward to detail view
					notificationRouter.showRemoteNotificationTarget(for: userInfo, doWaitForDataStore: false)
					completionHandler(.noData)
				} else {
					// Application is either in background or was already running in foreground
					let wasAlreadyActive = application.applicationState == .active
					DataStoreRefreshController.shared.add(NotificationSyncDataStoreRefreshDelegate(completionHandler: { result in
						// Prevent the notification from being shown again once the app has become active,
						// if the user foregrounded it by tapping on the background notification.
						if wasAlreadyActive {
							self.notificationRouter.showRemoteNotification(for: userInfo)
						}
						completionHandler(result)
					}))
					DataStoreRefreshController.shared.refreshStore(withDelta: true)
				}

			case .Notification: // There is something we should notify the user about, most likely new PMs.
				switch application.applicationState {
				case .inactive:
					// Application was launched from tapping the notification -> forward to PM view
					notificationRouter.showRemoteNotificationTarget(for: userInfo, doWaitForDataStore: false)
				case .active:
                    EurofurenceApplication.shared.fetchPrivateMessages { _ in }
					notificationRouter.showRemoteNotification(for: userInfo)
				case .background:
					UIApplication.shared.applicationIconBadgeNumber += 1
				}
				// TODO: Pull new PMs from server
				completionHandler(.noData)
			default:
				completionHandler(.noData)
				break
			}
		}
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}
