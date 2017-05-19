//
//  SyncEntityDelta.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-15.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class SyncEntityDelta<EntityType>: SyncEntityDeltaBase, EVGenericsKVC where EntityType:NSObject {
	var ChangedEntities : [EntityType] = []

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

class SyncEntityDeltaBase: EVObject {
	var DeletedEntities : [String] = []
	var RemoveAllBeforeInsert : Bool = true
	var StorageDeltaStartChangeDateTimeUtc : Date = Date()
	var StorageLastChangeDateTimeUtc : Date = Date()
}
