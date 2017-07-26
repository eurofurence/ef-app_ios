//
//  UserDetailsEventTablePreferences.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDetailsEventTablePreferences: EventTablePreferences {
	static let EventTableFilterEventFavoritesKey = "Eurofurence.EventTableFilterEventFavoritesKey"
	static let EventTableGroupingKey = "Eurofurence.EventTableGrouping"

	var doFilterEventFavorites: Bool {
		return userDefaults.bool(forKey: UserDetailsEventTablePreferences.EventTableFilterEventFavoritesKey)
	}
	var eventGrouping: EventTableGrouping {
		return EventTableGrouping(rawValue: userDefaults.integer(forKey: UserDetailsEventTablePreferences.EventTableGroupingKey)) ?? EventTableGrouping.ByDays
	}

	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
		userDefaults.register(defaults: [
			UserDetailsEventTablePreferences.EventTableFilterEventFavoritesKey: false,
			UserDetailsEventTablePreferences.EventTableGroupingKey: EventTableGrouping.ByDays.rawValue
			])
	}

	func setFilterEventFavorites(_ doFilterEventFavorites: Bool) {
		userDefaults.set(doFilterEventFavorites, forKey: UserDetailsEventTablePreferences.EventTableFilterEventFavoritesKey)
	}

	func setEventGrouping(_ eventGrouping: EventTableGrouping) {
		userDefaults.set(eventGrouping.rawValue, forKey: UserDetailsEventTablePreferences.EventTableGroupingKey)
	}
}
