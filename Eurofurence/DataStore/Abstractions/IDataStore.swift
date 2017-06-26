//
//  IDataStore.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
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
	func load<EntityType: EntityBase>(_ entityType: EntityType.Type) -> SignalProducer<DataStoreResult, DataStoreError>

	/**
	Deletes all entities from the store.
	*/
	func clearAll() -> SignalProducer<DataStoreResult, DataStoreError>

	/**
	Deletes all entities of entityType from the store.
	*/
	func clear(_ entityType: EntityBase.Type) -> SignalProducer<DataStoreResult, DataStoreError>

}

enum DataStoreError: CustomNSError {
	case NotImplemented(functionName: String)
	case FailedCreate(url: URL, description: String?)
	case FailedRead(entityType: String, description: String?)
	case FailedWrite(entityType: String, description: String?)
	case InvalidParameter(functionName: String, description: String?)

	static var errorDomain: String {
		return "DataStoreError"
	}

	var errorCode: Int {
		switch self {
		case .FailedCreate:
			return 2
		case .FailedRead:
			return 1
		case .FailedWrite:
			return 0
		case .InvalidParameter:
			return 400
		case .NotImplemented:
			return 501
		}
	}

	var errorUserInfo: [String : AnyObject] {
		switch self {
		case .FailedCreate(let url, let description):
			return ["message" : "File or directory at \(url) could not be created" as NSString,
			        "description" : (description ?? "") as NSString]
		case .FailedRead(let entityType, let description):
			return ["message" : "Entity of type \(entityType) could not be read" as NSString,
			        "description" : (description ?? "") as NSString]
		case .FailedWrite(let entityType, let description):
			return ["message" : "Entity of type \(entityType) could not be written" as NSString,
			        "description" : (description ?? "") as NSString]
		case .InvalidParameter(let functionName, let description):
			return ["message" : "Invalid parameter for function \(functionName)" as NSString,
			        "description" : (description ?? "") as NSString]
		case .NotImplemented(let functionName):
			return ["message" : "Function \(functionName) is not (yet) implemented" as NSString,
			        "description" : "" as NSString]
		}
	}
}
