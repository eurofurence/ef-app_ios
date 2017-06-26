//
//  ContextManager.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ContextManager {
	static let LAST_SYNC_DEFAULT = "lastSync"
	
	private static let scheduler = QueueScheduler(qos: .userInitiated, name: "org.eurofurence.app.ContextManagerScheduler")
	private var apiConnection: IApiConnection
	private var dataContext: IDataContext
	private var dataStore: IDataStore

	private(set) lazy var syncWithApi: Action<Int, Progress, NSError>? =
			Action { since in
				return SignalProducer<Progress, NSError> { observer, disposable in
					let progress = Progress(totalUnitCount: 3)

					disposable += self.apiConnection.doGet("Sync", parameters: ["since": since]).observe(on: ContextManager.scheduler).startWithResult({ (apiResult: Result<Sync, ApiConnectionError>) -> Void in
						
						progress.completedUnitCount += 1
						observer.send(value: progress)
						
						if let sync = apiResult.value {
							disposable += self.dataContext.applySync.apply(sync).startWithCompleted{
								progress.completedUnitCount += 1
								observer.send(value: progress)
								UserDefaults.standard.set(sync.CurrentDateTimeUtc, forKey: ContextManager.LAST_SYNC_DEFAULT)
								
								// TODO: Download images
								progress.completedUnitCount += 1
								observer.send(value: progress)
								observer.sendCompleted()
							}
						} else {
							// TODO: Rollback to last persisted state in order to maintain consistency
							observer.send(error: apiResult.error as NSError? ??
								ApiConnectionError.UnknownError(functionName: #function,
								                                description: "Unexpected empty value on sync result") as NSError)
						}
					})
				}.observe(on: ContextManager.scheduler)
			}

	init(apiConnection: IApiConnection, dataContext: IDataContext,
	     dataStore: IDataStore) {
		self.apiConnection = apiConnection
		self.dataContext = dataContext
		self.dataStore = dataStore
	}

	func clearAll() {
		dataStore.clearAll().startWithCompleted {
			self.dataContext.clearAll()
		}
	}
}
