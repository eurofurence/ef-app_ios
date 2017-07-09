//
//  RefreshControlDataStoreDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct RefreshControlDataStoreDelegate: DataStoreRefreshDelegate {

    var refreshControl: UIRefreshControl

	func dataStoreRefreshDidBegin(_ lastSync: Date?) {
        refreshControl.beginRefreshing()
    }

    func dataStoreRefreshDidFinish() {
        refreshControl.endRefreshing()
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {

    }

    func dataStoreRefreshDidFailWithError(_ error: Error) {
        refreshControl.endRefreshing()
    }

}
