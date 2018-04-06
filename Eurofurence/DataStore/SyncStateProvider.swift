//
//  SyncStateProvider.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class SyncStateProvider: LastSyncDateProviding, DataModelVersionProviding {
	var lastSyncDate: Date? {
		get {
			return dataContext.SyncState.value.LastSyncDate
		}
	}

	var dataModelVersions: [String: Int] {
		get {
			return dataContext.SyncState.value.DataModelVersions
		}
	}

	private let dataContext: DataContextProtocol

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext
	}

	func getDataModelVersion(for entityName: String) -> Int? {
		return dataModelVersions[entityName]
	}

	func setDataModelVersion(for entityName: String, version: Int) -> Bool {
		if let entityVersion = getDataModelVersion(for: entityName), entityVersion > version {
			return false
		}

		dataContext.SyncState.modify { $0.DataModelVersions[entityName] = version }
		return getDataModelVersion(for: entityName) == version
	}
}
