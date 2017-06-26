//
//  SharedFunctions.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Changeset

class DateFormatters {
	public static let hourMinute: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter
	}()
	
	public static let dayMonthLong: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEEE dd MMMM"
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		return formatter
	}()
}

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

extension EditOperation : Equatable {}

public func ==(lhs: EditOperation, rhs: EditOperation) -> Bool {
	switch (lhs, rhs) {
	case (.insertion, .insertion):
		return true
	case (.deletion, .deletion):
		return true
	case (.substitution, .substitution):
		return true
	case (let .move(lhsOrigin), let .move(rhsOrigin)):
		return lhsOrigin == rhsOrigin
	default:
		return false
	}
}

extension UIView {
	var isViewEmpty : Bool {
		return  self.subviews.count == 0 ;
	}
}

public extension UITableView {
	func registerCellClass(_ cellClass: AnyClass) {
		let identifier = String(describing: cellClass)
		self.register(cellClass, forCellReuseIdentifier: identifier)
	}
}
