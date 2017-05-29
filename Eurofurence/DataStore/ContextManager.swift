//
//  ContextManager.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-19.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift

class ContextManager {
	private var apiConnection: IApiConnection
	private var dataContext: IDataContext

	private(set) lazy var syncWithApi: SignalProducer<Progress, NSError>? =
			SignalProducer<Progress, NSError> { observer, disposable in
				let progress = Progress(totalUnitCount: 3)

				let apiResult = self.apiConnection.syncGet.last()
				progress.completedUnitCount += 1
				observer.send(value: progress)
				if let sync = apiResult?.value {
					self.dataContext.applySync(data: sync, saveBefore: true)
					progress.completedUnitCount += 1
					observer.send(value: progress)
				} else {
					observer.send(error: apiResult?.error ??
							NSError(domain: "EfApi", code: 999, userInfo:
							["text": "An unknown error occurred"]))
				}

				// TODO: Download images
				progress.completedUnitCount += 1
				observer.send(value: progress)

			}

	init(apiConnection: IApiConnection, dataContext: IDataContext,
	     dataStore: IDataStore) {
		self.apiConnection = apiConnection
		self.dataContext = dataContext
	}
}
