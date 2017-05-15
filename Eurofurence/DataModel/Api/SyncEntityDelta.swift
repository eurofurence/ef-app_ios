//
//  SyncEntityDelta.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-15.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class SyncEntityDelta<EntityType>: EVObject {
	var ChangedEntities : [EntityType] = []
	var DeletedEntities : [UUID] = []
	var RemoveAllBeforeInsert : Bool = true
	var StorageDeltaStartChangeDateTimeUtc : Date = Date()
	var StorageLastChangeDateTimeUtc : Date = Date()
}
