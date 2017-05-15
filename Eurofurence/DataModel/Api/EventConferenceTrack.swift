//
//  EventConferenceTrack.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class EventConferenceTrack: EntityBase {
	var Name = ""
    
	var Events : [Event]? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Events",keyInResource: nil)]
	}
}
