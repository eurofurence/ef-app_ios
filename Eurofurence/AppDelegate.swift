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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var lifetime = Lifetime.make()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

		PrintOptions.Active = .None

		let contextManager = try! ContextResolver.container.resolve() as ContextManager
		let dataContext = try! ContextResolver.container.resolve() as DataContextProtocol

		dataContext.loadFromStore().start(on: QueueScheduler.concurrent).start({ event in
			switch event {
			case let .value(value):
				print("Loading completed by \(value.fractionCompleted)")
			case let .failed(error):
				print("Failed to load data from store: \(error)")

				// TODO: Prompt user for required initialisation
				// TODO: Check WiFi connection and prompt user if on mobile
				print("Performing full reload from API")
				DataStoreRefreshController.shared.refreshStore()
			case .completed:
				print("Loading completed")
				// TODO: Check WiFi connection and prompt user if on mobile
				if UserSettings.UpdateOnStart.currentValueOrDefault() {
					DataStoreRefreshController.shared.refreshStore()
				}
			case .interrupted:
				print("Loading interrupted")
			}
		})

        window?.rootViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "MainTabBarController")
        window?.makeKeyAndVisible()

		return true
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
