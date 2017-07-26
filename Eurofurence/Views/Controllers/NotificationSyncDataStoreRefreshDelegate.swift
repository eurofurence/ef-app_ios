//
//  NotificationSyncDataStoreRefreshDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UserNotificationsUI

class NotificationSyncDataStoreRefreshDelegate: DataStoreRefreshDelegate {
	let completionHandler: (UIBackgroundFetchResult) -> Void

	init(completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		self.completionHandler = completionHandler
	}

	func dataStoreRefreshDidFailWithError(_ error: Error) {
		DataStoreRefreshController.shared.remove(self)
		completionHandler(.failed)
	}

	func dataStoreRefreshDidFinish() {
		DataStoreRefreshController.shared.remove(self)
		completionHandler(.newData)
	}

	func dataStoreRefreshDidBegin(_ lastSync: Date?) { }
	func dataStoreRefreshDidProduceProgress(_ progress: Progress) { }
}
