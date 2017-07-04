//
//  Event.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class Event : EntityBase {
	var Abstract : String = ""
    var ConferenceDayId : String = ""
    var ConferenceTrackId : String = ""
    var ConferenceRoomId : String = ""
    var Description : String = ""
	var Duration : TimeInterval = 0.0
	var EndDateTimeUtc : Date = Date()
	var EndTime : String = ""
	var IsDeviatingFromConBook : Bool = false
    var PanelHosts : String = ""
    var Slug : String = ""
	var SubTitle : String = ""
	var StartDateTimeUtc : Date = Date()
	var StartTime : String = ""
    var Title : String = ""
    
    var IsFavorite : Bool = false
	
    weak var ConferenceDay : EventConferenceDay? = nil
    weak var ConferenceTrack : EventConferenceTrack? = nil
	weak var ConferenceRoom : EventConferenceRoom? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "ConferenceDay",keyInResource: nil),
			        (keyInObject: "ConferenceTrack",keyInResource: nil),
					(keyInObject: "ConferenceRoom",keyInResource: nil)]
	}
	
	override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> ()), encodeConverter: (() -> Any?))] {
		return [
			(key: "Duration",
			 decodeConverter: {
				guard let timeString = $0 as? String else { return }
				self.Duration = TimeInterval.init(timeString: timeString) },
			 encodeConverter: { return "\(self.Duration.hoursPart):\(self.Duration.minutesPart):\(self.Duration.secondsPart)"})
		]
	}
}

extension Event: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? Event).map {
			return self.StartDateTimeUtc < $0.StartDateTimeUtc
			} ?? super.lessThan(rhs)
	}
}
