//
//  RefreshControlDataStoreDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class RefreshControlDataStoreDelegate: DataStoreRefreshDelegate {

    let refreshControl: UIRefreshControl

	init(refreshControl: UIRefreshControl) {
		self.refreshControl = refreshControl
	}

	func dataStoreRefreshDidBegin(_ lastSync: Date?) {
		var lastSyncText = "never"
		if let lastSync = lastSync {
			lastSyncText = DateFormatters.dateTimeShort.string(from: lastSync)
		}

		refreshControl.attributedTitle = NSAttributedString(string: "Last sync: \(lastSyncText)", attributes: [
			NSForegroundColorAttributeName: UIColor.lightText
			])
        refreshControl.beginRefreshing()
    }

	func dataStoreRefreshDidFinish() {
		refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [
			NSForegroundColorAttributeName: UIColor.lightText
			])
        refreshControl.endRefreshing()
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {

    }

    func dataStoreRefreshDidFailWithError(_ error: Error) {
        refreshControl.endRefreshing()
    }

}
