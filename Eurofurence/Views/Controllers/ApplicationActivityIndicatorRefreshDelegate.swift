//
//  ApplicationActivityIndicatorRefreshDelegate.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 07/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct ApplicationActivityIndicatorRefreshDelegate: DataStoreRefreshDelegate {

	func dataStoreRefreshDidBegin(_ lastSync: Date?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func dataStoreRefreshDidFinish() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func dataStoreRefreshDidFailWithError(_ error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func dataStoreRefreshDidProduceProgress(_ progress: Progress) {

    }

}
