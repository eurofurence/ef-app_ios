//
//  EventConferenceDay.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EventConferenceDay: EntityBase {
	var Date = Foundation.Date()
    var Name = ""
	
	var Events : [Event] = []
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Events",keyInResource: nil)]
	}
}

extension EventConferenceDay: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? EventConferenceDay).map {
			return self.Date < $0.Date
			} ?? super.lessThan(rhs)
	}
}
