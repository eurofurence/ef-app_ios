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
	private static let scheduler = QueueScheduler(qos: .userInitiated, name: "org.eurofurence.app.ContextManagerScheduler")
	private var apiConnection: ApiConnectionProtocol
	private var dataContext: DataContextProtocol
	private var dataStore: DataStoreProtocol
	private var imageService: ImageServiceProtocol

	private(set) lazy var syncWithApi: Action<Date?, Progress, NSError>? =
			Action { sinceDate in
				return SignalProducer<Progress, NSError> { [unowned self] observer, disposable in
					let progress = Progress(totalUnitCount: 200)
					let parameters: ApiConnectionProtocol.Parameters?
					if let sinceDate = sinceDate {
						let since = Iso8601DateFormatter.instance.string(from: sinceDate)
						parameters = ["since": since]
					} else {
						parameters = nil
					}

					disposable += self.apiConnection.doGet("Sync", parameters: parameters).observe(on: ContextManager.scheduler).startWithResult({ (apiResult: Result<Sync, ApiConnectionError>) -> Void in

						progress.completedUnitCount += 50
						observer.send(value: progress)

						if let sync = apiResult.value {
							disposable += self.dataContext.applySync.apply(sync).start { event in
								switch event {
								case let .value(value):
									print("Data context sync completed by \(value.fractionCompleted)")
								case let .failed(error):
									observer.send(error: error as NSError)
								case .completed:
									progress.completedUnitCount += 50
									observer.send(value: progress)

									disposable += self.imageService.refreshCache(for: self.dataContext.Images.value).start { event in
										switch event {
										case let .failed(error):
											observer.send(error: error as NSError)
										case .completed:
											progress.completedUnitCount = progress.totalUnitCount
											observer.send(value: progress)
											observer.sendCompleted()
										case let .value(imageProgress):
											progress.completedUnitCount = 100 + Int64(imageProgress.fractionCompleted * 100)
											observer.send(value: progress)
										default:
											break
										}
									}
								default:
									break
								}
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

	init(apiConnection: ApiConnectionProtocol, dataContext: DataContextProtocol,
	     dataStore: DataStoreProtocol, imageService: ImageServiceProtocol) {
		self.apiConnection = apiConnection
		self.dataContext = dataContext
		self.dataStore = dataStore
		self.imageService = imageService
	}

	func clearAll() {
		dataStore.clearAll().startWithCompleted {
			self.dataContext.clearAll()
			self.imageService.clearCache()
		}
	}
}
