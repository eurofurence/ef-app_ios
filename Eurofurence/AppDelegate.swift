//
//  AppDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import EurofurenceAppCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow? = UIWindow()
    var app: EurofurenceApplicationProtocol!
    private var director: ApplicationDirector?

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()
        installDebugModuleIntoWindow()
        Theme.apply()
        UNUserNotificationCenter.current().delegate = self

        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        let apiUrl = BuildConfigurationV2ApiUrlProviding(buildConfiguration)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                                                appVersion: BundleAppVersionProviding.shared,
                                                                                                firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                                fcmRegistration: fcmRegistration)

        let pushPermissionsRequester = ApplicationPushPermissionsRequester.shared

        let significantTimeChangeEventSource = ApplicationSignificantTimeChangeEventSource.shared

        let significantTimeChangeAdapter = ApplicationSignificantTimeChangeAdapter()

        let urlOpener = AppURLOpener()

        let longRunningTaskManager = ApplicationLongRunningTaskManager()

        let notificationsService = UserNotificationsNotificationService()

        let mapCoordinateRender = UIKitMapCoordinateRender()

        app = EurofurenceApplicationBuilder()
            .with(remoteNotificationsTokenRegistration)
            .with(pushPermissionsRequester)
            .with(significantTimeChangeAdapter)
            .with(urlOpener)
            .with(longRunningTaskManager)
            .with(notificationsService)
            .with(mapCoordinateRender)
            .build()

        let director = DirectorBuilder().build()
        self.director = director
        app.setExternalContentHandler(director)

        window?.makeKeyAndVisible()
        ReviewPromptController.initialize()

		return true
	}

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        app.storeRemoteNotificationsToken(deviceToken)
    }

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        director?.handleRemoteNotification(userInfo, completionHandler: completionHandler)
	}

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        director?.openNotification(response.notification.request.content.userInfo, completionHandler: completionHandler)
    }

}

// MARK: - Debug Window

extension AppDelegate {

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

}
