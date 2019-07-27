//
//  Iso8601DateFormatter.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

/**
Simple, hacky fix to support creating Dates from ISO8601 timestamps with and
without fractional seconds.
*/
public class Iso8601DateFormatter: DateFormatter {
	public static let instance = Iso8601DateFormatter()
	public let noFractionsDateFormatter = DateFormatter()

	override public init() {
		super.init()

		locale = Locale(identifier: "en_US_POSIX")
		timeZone = TimeZone(secondsFromGMT: 0)
		dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"

		noFractionsDateFormatter.locale = Locale(identifier: "en_US_POSIX")
		noFractionsDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
		noFractionsDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override public func date(from string: String) -> Date? {
		if let date = noFractionsDateFormatter.date(from: string) {
			return date
		}

		return super.date(from: string)
	}

	override public func string(from date: Date) -> String {
		return super.string(from: date)
	}
}
