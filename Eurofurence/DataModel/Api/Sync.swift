//
//  Sync.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-15.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class Sync: EVObject {
	var Announcements : SyncEntityDelta<Announcement> = SyncEntityDelta()
	var CurrentDateTimeUtc : Date = Date()
	var Dealers : SyncEntityDelta<Dealer> = SyncEntityDelta()
	var Events : SyncEntityDelta<Event> = SyncEntityDelta()
	var EventConferenceDays : SyncEntityDelta<EventConferenceDay> = SyncEntityDelta()
	var EventsConferenceRooms : SyncEntityDelta<EventConferenceRoom> = SyncEntityDelta()
	var EventsConferenceTracks : SyncEntityDelta<EventConferenceTrack> = SyncEntityDelta()
	var Images : SyncEntityDelta<Image> = SyncEntityDelta()
	var KnowledgeEntries : SyncEntityDelta<KnowledgeEntry> = SyncEntityDelta()
	var KnowledgeGroups : SyncEntityDelta<KnowledgeGroup> = SyncEntityDelta()
	var Since : Date? = nil
	
	let Map : Map? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Map",keyInResource: nil)]
	}
}
