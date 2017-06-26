//
//  AppDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift
import EVReflection
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var lifetime = Lifetime.make()


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		PrintOptions.Active = .None
		
		let timeService = try! ServiceResolver.container.resolve() as TimeService
		timeService.offset = Date(timeIntervalSince1970: 1503081000.0).timeIntervalSince(Date())

		let contextManager = try! ContextResolver.container.resolve(tag: Environment.Development) as ContextManager
		let dataContext = try! ContextResolver.container.resolve() as IDataContext
		
		dataContext.loadFromStore().start(on: QueueScheduler.concurrent).start({ event in
			switch event {
			case let .value(value):
				print("Loading completed by \(value.fractionCompleted)")
			case let .failed(error):
				print("Failed to load data from store: \(error)")
				print("Performing full reload from API")
				
				contextManager.syncWithApi?.apply(0).start({ event in
					guard let value = event.value else {
						print("Error during sync: \(String(describing: event.error))")
						// TODO: Display error message and option to retry sync
						return
					}
					print("Sync completed by \(value.fractionCompleted)")
				})
			case .completed:
				print("Loading completed")
			case .interrupted:
				print("Loading interrupted")
			}
		})
		
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

