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
	/// UTC based DateFormatter using a YYYY-MM-dd HH:mm:ss format
	public static let dateTimeShort: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
		return formatter
	}()
	/// UTC based DateFormatter using a HH:mm format
	public static let hourMinute: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "HH:mm"
		return formatter
	}()

	/// UTC based DateFormatter using an EEEE format
	public static let weekdayLong: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEEE"
		return formatter
	}()

	/// UTC based DateFormatter using an EEEE dd MMMM format
	public static let dayMonthLong: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEEE dd MMMM"
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
	/// Sets the isExcludedFromBackup ResourceValue to exclude for the resource
	/// represented by the URL.
	mutating func setExcludedFromBackup(_ exclude: Bool) throws {
		if FileManager.default.fileExists(atPath: self.path) {
			var resourceValues = URLResourceValues()
			resourceValues.isExcludedFromBackup = true
			try self.setResourceValues(resourceValues)
		}
	}
}

extension EditOperation: Equatable {}

/// Makes Changeset's EditOperation equatable
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
	/// Checks if the view contains any subviews
	var isViewEmpty: Bool {
		return  self.subviews.count == 0
	}
}

public extension UITableView {
	/// Registers cellClass using its name as identifier for the call to
	/// register(:AnyClass:String).
	func registerCellClass(_ cellClass: AnyClass) {
		let identifier = String(describing: cellClass)
		self.register(cellClass, forCellReuseIdentifier: identifier)
	}
}

extension Collection {
	/// Checks whether index is within the collection's bounds and returns null if not.
	subscript (safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

extension TimeInterval {
	/// Converts a timespan represented in H:i:s format to seconds, defaulting to
	/// a value of 0 upon failure.
	init(timeString: String) {
		self = 0
		guard !timeString.isEmpty else {
			return
		}

		let parts = timeString.components(separatedBy: ":")
		for (index, part) in parts.reversed().enumerated() {
			if index > 2 { break }
			self += (Double(part) ?? 0) * pow(Double(60), Double(index))
		}
	}

	/// Interval in seconds
	var seconds: Double { get { return self }}
	/// Interval in seconds
	var minutes: Double { get { return seconds / 60 }}
	/// Interval in seconds
	var hours: Double { get { return minutes / 60 }}
	/// Interval in seconds
	var days: Double { get { return hours / 24 }}
	/// Interval in years (365 days per year)
	var years: Double { get { return days / 365 }}

	/// Seconds part of TimeInterval representation
	var secondsPart: Int { get { return Int(seconds.truncatingRemainder(dividingBy: 60)) }}
	/// Minutes part of TimeInterval representation
	var minutesPart: Int { get { return Int(minutes.truncatingRemainder(dividingBy: 60)) }}
	/// Hours part of TimeInterval representation
	var hoursPart: Int { get { return Int(hours.truncatingRemainder(dividingBy: 24)) }}
	/// Days part of TimeInterval representation
	var daysPart: Int { get { return Int(days.truncatingRemainder(dividingBy: 365)) }}
	/// Years part of TimeInterval representation
	var yearsPart: Int { get { return Int(years) }}

	/// String representation of interval's days, hours and minutes in the form
	/// of "[[$daysPart day[s]] $hoursPart hour[s]] $minutesPart minute[s]" or
	/// an empty string for a duration of less than a minute. 
	var dhmString: String {
		get {
			var stringParts: [String] = []
			if daysPart > 0 {
				stringParts.append("\(daysPart) day\(daysPart == 1 ? "" : "s")")
			}
			if hoursPart > 0 {
				stringParts.append("\(hoursPart) hour\(hoursPart == 1 ? "" : "s")")
			}
			if minutesPart > 0 {
				stringParts.append("\(minutesPart) minute\(minutesPart == 1 ? "" : "s")")
			}

			return stringParts.joined(separator: " ")
		}
	}

	/// String representing the biggest time unit which is capable of
	/// representing the TimeInterval with a value greater than zero.
	var biggestUnitString: String {
		if yearsPart >= 1 {
			return "\(yearsPart) year\(yearsPart == 1 ? "" : "s")"
		} else if daysPart >= 1 {
			return "\(daysPart) day\(daysPart == 1 ? "" : "s")"
		} else if hoursPart >= 1 {
			return "\(hoursPart) hour\(hoursPart == 1 ? "" : "s")"
		} else if minutesPart >= 1 {
			return "\(minutesPart) minute\(minutesPart == 1 ? "" : "s")"
		} else {
			return "\(secondsPart) second\(secondsPart == 1 ? "" : "s")"
		}
	}
}

extension Character {
	/// Create a new Character from the string representation of its unicode
	/// address.
	init?(unicodeScalarString: String) {
		guard let intValue = Int.init(unicodeScalarString, radix: 16),
			let unicodeScalar = UnicodeScalar.init(intValue) else {
				return nil
		}
		self = Character.init(unicodeScalar)
	}
}
