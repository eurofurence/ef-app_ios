//
//  PostDataStoreRoutingDelegate.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class PostDataStoreRoutingDelegate: DataStoreRefreshDelegate, DataStoreLoadDelegate {
	let targetRouter: TargetRouter
	var target: RoutingTarget
	let lazyPayload: [String : ()->Any?]?

	init(targetRouter: TargetRouter, target: RoutingTarget, lazyPayload: [String : ()->Any?]? = nil) {
		self.targetRouter = targetRouter
		self.target = target
		self.lazyPayload = lazyPayload
	}

	private func resolveLazyPayload() {
		if let lazyPayload = lazyPayload {
			var targetPayload = target.payload ?? [:]
			lazyPayload.forEach({ (key, value) in
				if let value = value() {
					targetPayload.updateValue(value, forKey: key)
				}
			})
			target.payload = targetPayload
		}
	}

	func dataStoreRefreshDidFailWithError(_ error: Error) {
		DataStoreRefreshController.shared.remove(self)
		DataStoreLoadController.shared.remove(self)
	}

	func dataStoreRefreshDidFinish() {
		DataStoreRefreshController.shared.remove(self)
		DataStoreLoadController.shared.remove(self)
		resolveLazyPayload()
		targetRouter.show(target: target)
	}

	func dataStoreLoadDidFinish() {
		DataStoreRefreshController.shared.remove(self)
		DataStoreLoadController.shared.remove(self)
		resolveLazyPayload()
		targetRouter.show(target: target)
	}

	func dataStoreLoadDidProduceProgress(_ progress: Progress) { }
	func dataStoreLoadDidBegin() { }
	func dataStoreRefreshDidBegin(_ lastSync: Date?) { }
	func dataStoreRefreshDidProduceProgress(_ progress: Progress) { }
}
