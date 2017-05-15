//
//  Announcement.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class Announcement: EntityBase {
	var Area : String = ""
	var Author : String = ""
	var Content : String = ""
	var Title : String = ""
	var ValidFromDateTimeUtc : Date = Date()
	var ValidUntilDateTimeUtc : Date = Date()
}

extension Announcement {
	/// Checks whether this entity is valid at the timestamp given in
	/// `dateTimeUtc`, which must adhere to the format `yyyy-MM-dd'T'HH:mm:ss.SSSZ`.
	///
	/// - returns: true if `dateTimeUtc` is between `ValidFromDateTimeUtc` inclusive
	///     and `ValidUntilDateTimeUtc` inclusive. If either boundary is invalid,
	///     it will be ignored.
	func isValidAtDateTimeUtcString(_ dateTimeUtcString: String)->Bool {
		let dateTimeUtc = NSDate(isoString: dateTimeUtcString)
		
		return dateTimeUtc != nil && isValidAtDateTimeUtc(dateTimeUtc!)
	}
	
	/// Checks whether this entity is valid at `dateTimeUtc`.
	///
	/// - returns: true if `dateTimeUtc` is between `ValidFromDateTimeUtc` inclusive
	///     and `ValidUntilDateTimeUtc` inclusive. If either boundary is invalid,
	///     it will be ignored.
	func isValidAtDateTimeUtc(_ dateTimeUtc: NSDate)->Bool {
		return (dateTimeUtc.compare(ValidFromDateTimeUtc as Date) == ComparisonResult.orderedDescending ||
			dateTimeUtc.compare(ValidFromDateTimeUtc as Date) == ComparisonResult.orderedSame) &&
			(dateTimeUtc.compare(ValidUntilDateTimeUtc as Date) == ComparisonResult.orderedAscending ||
				dateTimeUtc.compare(ValidUntilDateTimeUtc as Date) == ComparisonResult.orderedSame)
	}
}
