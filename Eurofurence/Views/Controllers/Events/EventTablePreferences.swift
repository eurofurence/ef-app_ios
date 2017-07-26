//
//  EventTablePreferences.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol EventTablePreferences {
	var doFilterEventFavorites: Bool { get }
	var eventGrouping: EventTableGrouping { get }

	func setFilterEventFavorites(_ doFilterEventFavorites: Bool)
	func setEventGrouping(_ eventGrouping: EventTableGrouping)
}

enum EventTableGrouping: Int {
	case ByDays = 0
	case ByRooms = 1
	case ByTracks = 2
}
