//
//  ContextManager.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-19.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class ContextManager {
	private var apiConnection: IApiConnection
	private var dataContext: IDataContext
	private var dataStore: IDataStore

	private(set) lazy var syncWithApi: Action<Int, Progress, NSError>? =
			Action { since in
				return SignalProducer<Progress, NSError> { observer, disposable in
					let progress = Progress(totalUnitCount: 3)

					let apiResult: Result<Sync, ApiConnectionError>? = self.apiConnection.doGet("Sync", parameters: ["since": since]).last()
					progress.completedUnitCount += 1
					observer.send(value: progress)

					if let sync = apiResult?.value {
						self.dataContext.applySync(data: sync, saveBefore: true)
						progress.completedUnitCount += 1
						observer.send(value: progress)
					} else {
						observer.send(error: apiResult?.error as NSError? ??
								ApiConnectionError.UnknownError(functionName: #function,
										description: "Unexpected empty value on sync result") as NSError)
					}

					// TODO: Download images
					progress.completedUnitCount += 1
					observer.send(value: progress)

				}
			}

	init(apiConnection: IApiConnection, dataContext: IDataContext,
	     dataStore: IDataStore) {
		self.apiConnection = apiConnection
		self.dataContext = dataContext
		self.dataStore = dataStore
	}

	func clearAll() {
		dataStore.clearAll().last()
		dataContext.clearAll()
	}
}
