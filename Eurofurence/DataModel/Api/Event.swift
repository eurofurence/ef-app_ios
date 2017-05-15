//
//  Event.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class Event : EntityBase {
	var Abstract : String = ""
    var ConferenceDayId : UUID = UUID()
    var ConferenceTrackId : UUID = UUID()
    var ConferenceRoomId : UUID = UUID()
    var Description : String = ""
	var Duration : Int = 0
	var EndTimeDateTimeUtc : Date = Date()
	var EndTime : String = ""
	var IsDeviatingFromConBook : Bool = false
    var PanelHosts : String = ""
    var Slug : String = ""
	var SubTitle : String = ""
	var StartDateTimeUtc : Date = Date()
	var StartTime : String = ""
    var Title : String = ""
    
    var IsFavorite : Bool = false
	
    var ConferenceDay : EventConferenceDay? = nil
    var ConferenceTrack : EventConferenceTrack? = nil
	var ConferenceRoom : EventConferenceRoom? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "ConferenceDay",keyInResource: nil),
			        (keyInObject: "ConferenceTrack",keyInResource: nil),
					(keyInObject: "ConferenceRoom",keyInResource: nil)]
	}
}

extension Event : Comparable {
	static func < (lhs: Event, rhs: Event) -> Bool {
		return lhs.StartDateTimeUtc < rhs.StartDateTimeUtc
	}
}
