//
//  EventConferenceRoom.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EventConferenceRoom: EntityBase {
	var Name = ""
    
	var Events : [Event] = []
	weak var MapEntry : MapEntry?
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Events",keyInResource: nil)]
	}
}

extension EventConferenceRoom: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? EventConferenceRoom).map {
			return self.Name < $0.Name
			} ?? super.lessThan(rhs)
	}
}
