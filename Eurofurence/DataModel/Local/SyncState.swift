//
//  SyncState.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class SyncState: EntityBase {
	override class var DataModelVersion: Int { return 1 + super.DataModelVersion }

	var DataModelVersions: [String: Int] = [:]
	var LastSyncDate: Date?

	required init() {
		super.init()

		// SyncState is unique and therefore provided with a static UUID
		Id = "f2b0131b-d570-4a93-8ef7-d93aaf4bb84d"
	}

	override func setValue(_ value: Any!, forUndefinedKey key: String) {
		switch key {
		case "DataModelVersions":
			// Dictionary requires manual mapping for the time being
			if let dict = value as? NSDictionary {
				self.DataModelVersions = [:]
				for (key, value) in dict {
					self.DataModelVersions[key as? String ?? ""] = value as? Int
				}
			}
		default:
			self.addStatusMessage(.IncorrectKey, message: "SetValue for key '\(key)' should be handled.")
			print("---> setValue for key '\(key)' should be handled.")
		}
	}
}
