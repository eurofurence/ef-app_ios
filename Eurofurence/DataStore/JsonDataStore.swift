//
//  JsonDataStore.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-20.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift
import EVReflection

class JsonDataStore: IDataStore {
	private let scheduler = QueueScheduler.concurrent
	private let directory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
	private let fileExtension = ".json"

	func load(_ entityType: EntityBase.Type) -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, disposable) in
			do {
				observer.send(value: try self.handleLoad(entityType))
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	func save<EntityType:EntityBase>(_ entityType: EntityType.Type, entityData: [EntityType]) -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, disposable) in
			do {
				observer.send(value: try self.handleSave(entityType, entityData: entityData))
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	func clear(_ entityType: EntityBase.Type) -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, disposable) in
			do {
				observer.send(value: try self.handleClear(entityType))
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	func clearAll() -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, disposable) in
			do {
				observer.send(value: try self.handleClearAll())
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	private func handleLoad(_ entityType: EntityBase.Type) throws -> DataStoreResult {
		print("Handling load request for \(String(describing: entityType))")

		if let path = directory.appendingPathComponent("\(String(describing: entityType))\(fileExtension)", isDirectory: false) {
			do {
				let json = try String(contentsOf: path, encoding: .utf8)
				return try DataStoreResult(.load, entityType: entityType, entityData: entityType.arrayFromJson(json))
			} catch let error as DataStoreError {
				throw error
			} catch let error {
				throw DataStoreError.FailedRead(entityType: String(describing: entityType), description: "Error: \(error)")
			}
		} else {
			throw DataStoreError.FailedRead(entityType: String(describing: entityType), description: "Failed to create path")
		}
	}

	private func handleSave<EntityType:EntityBase>(_ entityType: EntityType.Type, entityData: [EntityType]) throws -> DataStoreResult {
		print("Handling save request for \(String(describing: entityType))")

		if entityData.count == 0 {
			return try handleClear(entityType)
		}

		do {
			if let path = directory.appendingPathComponent("\(String(describing: entityType))\(fileExtension)") {
				try entityData.toJsonString().write(toFile: path.path, atomically: true, encoding: .utf8)
				return try DataStoreResult(.save, entityType: entityType)
			} else {
				throw DataStoreError.FailedWrite(entityType: String(describing: entityType), description: "Failed to create path")
			}
		} catch let error as DataStoreError {
			throw error
		} catch let error {
			throw DataStoreError.FailedWrite(entityType: String(describing: entityType), description: "Error: \(error)")
		}
	}

	private func handleClear(_ entityType: EntityBase.Type) throws -> DataStoreResult {
		print("Handling clear request for \(String(describing: entityType))")
		throw DataStoreError.NotImplemented(functionName: #function)
	}

	private func handleClearAll() throws -> DataStoreResult {
		print("Handling clearAll request")
		throw DataStoreError.NotImplemented(functionName: #function)
	}
}
