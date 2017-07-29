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

	var window: UIWindow?
    var app: EurofurenceApplication = .shared
	lazy var targetRouter: TargetRouter = StoryboardTargetRouter(window: self.window!)
	lazy var notificationRouter: NotificationRouter = StoryboardNotificationRouter(window: self.window!, targetRouter: self.targetRouter)

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()

		try! ContextResolver.container.bootstrap()
		try! ServiceResolver.container.bootstrap()
		try! ViewModelResolver.container.bootstrap()

		PrintOptions.Active = .None

        DataStoreRefreshController.shared.add(ApplicationActivityIndicatorRefreshDelegate())
		PresentationTier.assemble(window: window!)

		// App was launched from local or remote notification
		if let notification = launchOptions?[.localNotification] as? UILocalNotification {
			notificationRouter.showLocalNotificationTarget(for: notification, doWaitForDataStore: true)
		} else if let userInfo = launchOptions?[.remoteNotification] as? [AnyHashable : Any] {
			notificationRouter.showRemoteNotificationTarget(for: userInfo, doWaitForDataStore: true)
		}

		return true
	}

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        app.registerRemoteNotifications(deviceToken: deviceToken)
        PresentationTier.pushRequesting.handlePushRegistrationSuccess()
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PresentationTier.pushRequesting.handlePushRegistrationFailure()
	}

	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		if application.applicationState == .inactive {
			notificationRouter.showLocalNotificationTarget(for: notification, doWaitForDataStore: false)
		} else if application.applicationState == .active {
			notificationRouter.showLocalNotification(for: notification)
		}
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
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
					notificationRouter.showRemoteNotification(for: userInfo)
				case .background:
					break
				}
				// TODO: Pull new PMs from server
				completionHandler(.noData)
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
