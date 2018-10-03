//
//  AppDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow? = UIWindow()
    lazy var app = EurofurenceApplication.shared
    private var director: ApplicationDirector?

	func application(_ application: UIApplication,
	                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ScreenshotAssistant.prepare()
        FirebaseApp.configure()
        installDebugModuleIntoWindow()
        applyDirectorBasedTheme()
        UNUserNotificationCenter.current().delegate = self

            let director = DirectorBuilder().build()
            self.director = director
            EurofurenceApplication.shared.setExternalContentHandler(director)

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

// MARK: - Themeing

extension AppDelegate {

    private func makePantone330UShadowImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return renderer.image { (context) in
            UIColor.pantone330U.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }

    private func applyDirectorBasedTheme() {
        let whiteTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
        let pantone330UColourImage = makePantone330UShadowImage()

        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.isTranslucent = false
        navigationBarAppearance.barTintColor = .pantone330U
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.titleTextAttributes = whiteTextAttributes
        navigationBarAppearance.setBackgroundImage(pantone330UColourImage, for: .default)
        navigationBarAppearance.shadowImage = pantone330UColourImage

        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = false
        tabBarAppearance.barTintColor = .pantone330U
        tabBarAppearance.tintColor = .white
        tabBarAppearance.backgroundImage = pantone330UColourImage
        tabBarAppearance.shadowImage = pantone330UColourImage

        let buttonInsideTableView = UIButton.appearance(whenContainedInInstancesOf: [UITableViewCell.self])
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

        let segmentControlAppearance = UISegmentedControl.appearance()
        segmentControlAppearance.tintColor = .white
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
