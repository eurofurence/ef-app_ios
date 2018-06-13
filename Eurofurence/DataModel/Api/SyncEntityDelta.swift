//
//  SyncEntityDelta.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

/**
Provides a generic wrapper for entity deltas supplied by Sync
*/
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

/**
Base protocol for generic wrapper. Necessary due to internal implementation
details of EVReflection (see documentation for details).
*/
@objcMembers
class SyncEntityDeltaBase: EVNetworkingObject {
	var DeletedEntities: [String] = []
	var RemoveAllBeforeInsert: Bool = true
	var StorageDeltaStartChangeDateTimeUtc: Date = Date()
	var StorageLastChangeDateTimeUtc: Date = Date()
}
