//
//  SyncStateProvider.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class SyncStateProvider: LastSyncDateProviding {
	var lastSyncDate: Date? {
		get {
			return dataContext.SyncState.value.LastSyncDate
		}
	}

	private let dataContext: DataContextProtocol

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext
	}
}
