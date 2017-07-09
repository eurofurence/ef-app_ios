//
//  SyncState.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class SyncState: EntityBase {
	var LastSyncDate: Date?

	required init() {
		super.init()

		// SyncState is unique and therefore provided with a static UUID
		Id = "f2b0131b-d570-4a93-8ef7-d93aaf4bb84d"
	}
}
