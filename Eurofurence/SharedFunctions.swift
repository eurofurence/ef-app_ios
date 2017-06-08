//
//  SharedFunctions.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift

extension QueueScheduler {
	static var concurrent: QueueScheduler {
		// a single QueueScheduler enforces serial FIFO execution of scheduled blocks. To allow for concurrent execution
		// we instead use a pool of QueueSchedulers and rotate them as they are accessed
		return self.concurrentSchedulers.modify { schedulers in
			let scheduler = schedulers.removeFirst()
			schedulers.append(scheduler)
			return scheduler
		}
	}

	private static var concurrentSchedulers = Atomic<[QueueScheduler]>([
			QueueScheduler(qos: .default, name: "concurrent"),
			QueueScheduler(qos: .default, name: "concurrent"),
			QueueScheduler(qos: .default, name: "concurrent"),
			QueueScheduler(qos: .default, name: "concurrent"),
			QueueScheduler(qos: .default, name: "concurrent"),
			QueueScheduler(qos: .default, name: "concurrent"),
			QueueScheduler(qos: .default, name: "concurrent"),
			QueueScheduler(qos: .default, name: "concurrent")
	])
}

extension URL {
	mutating func setExcludedFromBackup(_ exclude: Bool) throws {
		if FileManager.default.fileExists(atPath: self.path) {
			var resourceValues = URLResourceValues()
			resourceValues.isExcludedFromBackup = true
			try self.setResourceValues(resourceValues)
		}
	}
}