//
//  SyncEntityDelta.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class SyncEntityDelta<EntityType>: SyncEntityDeltaBase, EVGenericsKVC where EntityType: NSObject {
	var ChangedEntities: [EntityType] = []

	public func setGenericValue(_ value: AnyObject!, forUndefinedKey key: String) {
		switch key {
		case "ChangedEntities":
			ChangedEntities = value as? [EntityType] ?? [EntityType]()
		default:
			print("---> setGenericValue '\(value)' forUndefinedKey '\(key)' should be handled.")
		}
	}

	public func getGenericType() -> NSObject {
		return EntityType()
	}
}

class SyncEntityDeltaBase: EVNetworkingObject {
	var DeletedEntities: [String] = []
	var RemoveAllBeforeInsert: Bool = true
	var StorageDeltaStartChangeDateTimeUtc: Date = Date()
	var StorageLastChangeDateTimeUtc: Date = Date()
}
