//
//  IDataStore.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-09.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol IDataStore {
	/**
	Takes an array of entities to be stored.
	
	- parameters:
		- entityType: type of entity to be persisted
		- entityData: array of entityType to be stored
	- returns: Signal which may yield true or false depending on success of the operation
	*/
	func save<EntityType:EntityBase>(_ entityType: EntityType.Type, entityData: [EntityType]) -> SignalProducer<DataStoreResult, DataStoreError>

	/**
	Retrieves all entities of EntityType from the store.
	*/
	func load(_ entityType: EntityBase.Type) -> SignalProducer<DataStoreResult, DataStoreError>

	/**
	Deletes all entities from the store.
	*/
	func clearAll() -> SignalProducer<DataStoreResult, DataStoreError>

	/**
	Deletes all entities of entityType from the store.
	*/
	func clear(_ entityType: EntityBase.Type) -> SignalProducer<DataStoreResult, DataStoreError>

}

enum DataStoreError: Error {
	case NotImplemented(functionName: String)
	case FailedRead(entityType: String, description: String?)
	case FailedWrite(entityType: String, description: String?)
	case InvalidParameter(functionName: String, description: String?)
}