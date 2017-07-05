//
//  JsonDataStore.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

// TODO: versioning for data store model -> detect incompatibility between stored data and current model

import Foundation
import ReactiveSwift
import EVReflection

/**
JSON-based implementation for offline, on-device data storage.
*/
class JsonDataStore: DataStoreProtocol {
	private let scheduler = QueueScheduler(qos: .userInitiated, name: "DataStore")
	private let baseDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
	private var storeDirectory: URL?
	private let storeDirectoryName = "Store"
	private let fileExtension = ".json"

	func load<EntityType: EntityBase>(_ entityType: EntityType.Type) -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, _) in
			do {
				observer.send(value: try self.handleLoad(entityType))
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	func save<EntityType: EntityBase>(_ entityType: EntityType.Type, entityData: [EntityType]) -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, _) in
			do {
				observer.send(value: try self.handleSave(entityType, entityData: entityData))
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	func clear(_ entityType: EntityBase.Type) -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, _) in
			do {
				observer.send(value: try self.handleClear(entityType))
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	func clearAll() -> SignalProducer<DataStoreResult, DataStoreError> {
		return SignalProducer<DataStoreResult, DataStoreError>.init({ (observer, _) in
			do {
				observer.send(value: try self.handleClearAll())
				observer.sendCompleted()
			} catch {
				observer.send(error: error as! DataStoreError)
			}
		}).start(on: scheduler)
	}

	private func getStorePath(_ entityType: EntityBase.Type? = nil) throws -> URL {
		if storeDirectory == nil {
			var _storeDirectory = baseDirectory.appendingPathComponent(storeDirectoryName, isDirectory: true)

			if !FileManager.default.fileExists(atPath: _storeDirectory.path) {
				do {
					try FileManager.default.createDirectory(at: _storeDirectory, withIntermediateDirectories: true)
					try _storeDirectory.setExcludedFromBackup(true)
				} catch {
					throw DataStoreError.FailedCreate(url: _storeDirectory, description: "Attempted to create and exclude directory from backup")
				}
			}

			storeDirectory = _storeDirectory
		}

		if let entityType = entityType {
			return storeDirectory!.appendingPathComponent("\(String(describing: entityType))\(fileExtension)", isDirectory: false)
		} else {
			return storeDirectory!
		}
	}

	private func handleLoad<EntityType: EntityBase>(_ entityType: EntityType.Type) throws -> DataStoreResult {
		print("Handling load request for \(String(describing: entityType))")

		do {
			let storePath = try getStorePath(entityType)
			let json = try String(contentsOf: storePath, encoding: .utf8)
			let entityData = entityType.arrayFromJson(json) as [EntityType]
			return try DataStoreResult(.load, entityType: entityType, entityData: entityData)
		} catch let error as DataStoreError {
			throw error
		} catch let error {
			throw DataStoreError.FailedRead(entityType: String(describing: entityType), description: "Error: \(error)")
		}
	}

	private func handleSave<EntityType: EntityBase>(_ entityType: EntityType.Type, entityData: [EntityType]) throws -> DataStoreResult {
		print("Handling save request for \(String(describing: entityType))")

		if entityData.count == 0 {
			return try handleClear(entityType)
		}

		do {
			var storePath = try getStorePath(entityType)
			try entityData.toJsonString().write(to: storePath, atomically: true, encoding: .utf8)
			try storePath.setExcludedFromBackup(true)
			return try DataStoreResult(.save, entityType: entityType)
		} catch let error as DataStoreError {
			throw error
		} catch let error {
			throw DataStoreError.FailedWrite(entityType: String(describing: entityType), description: "Error: \(error)")
		}
	}

	private func handleClear(_ entityType: EntityBase.Type) throws -> DataStoreResult {
		print("Handling clear request for \(String(describing: entityType))")
		do {
			let storePath = try getStorePath(entityType)
			try FileManager.default.removeItem(at: storePath)
		} catch {
			/*  */
		}
		return try! DataStoreResult(.clear, entityType: entityType)
	}

	private func handleClearAll() throws -> DataStoreResult {
		print("Handling clearAll request")

		do {
			for fileUrl in try FileManager.default.contentsOfDirectory(at: try getStorePath(), includingPropertiesForKeys: [],
					options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles]) {
				try FileManager.default.removeItem(at: fileUrl)
			}
		} catch {
			/*  */
		}
		return try! DataStoreResult(.clearAll)
	}
}
