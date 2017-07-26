//
//  NotificationSyncDataStoreRefreshDelegate.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 26.07.17.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UserNotificationsUI

class NotificationSyncDataStoreRefreshDelegate: DataStoreRefreshDelegate {
	let completionHandler: (UIBackgroundFetchResult) -> Void
	let successHandler: (() -> Void)?

	init(successHandler: (() -> Void)? = nil, completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		self.successHandler = successHandler
		self.completionHandler = completionHandler
	}

	func dataStoreRefreshDidBegin(_ lastSync: Date?) { }

	func dataStoreRefreshDidFailWithError(_ error: Error) {
		DataStoreRefreshController.shared.remove(self)
		completionHandler(.failed)
	}

	func dataStoreRefreshDidFinish() {
		DataStoreRefreshController.shared.remove(self)
		successHandler?()
		completionHandler(.newData)
	}

	func dataStoreRefreshDidProduceProgress(_ progress: Progress) { }
}
