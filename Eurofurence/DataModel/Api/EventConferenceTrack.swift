//
//  EventConferenceTrack.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class EventConferenceTrack: EntityBase {
	var Name = ""
    
	var Events : [Event] = []
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Events",keyInResource: nil)]
	}
}

extension EventConferenceTrack: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? EventConferenceTrack).map {
			return self.Name < $0.Name
			} ?? super.lessThan(rhs)
	}
}
