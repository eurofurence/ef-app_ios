//
//  UserDetailsNewsPreferences.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct UserDetailsNewsPreferences: AnnouncementsShowAllProviding, CurrentEventsFilterFavoritesProviding {

	static let NewsFilterEventFavoritesKey = "Eurofurence.NewsFilterEventFavoritesKey"
	static let ShowAllAnnouncementsKey = "Eurofurence.ShowAllAnnouncementsKey"

	var doFilterEventFavorites: Bool {
		return userDefaults.bool(forKey: UserDetailsNewsPreferences.NewsFilterEventFavoritesKey)
	}
	var doShowAllAnnouncements: Bool {
		return userDefaults.bool(forKey: UserDetailsNewsPreferences.ShowAllAnnouncementsKey)
	}

	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
		userDefaults.register(defaults: [
			UserDetailsNewsPreferences.NewsFilterEventFavoritesKey: false,
			UserDetailsNewsPreferences.ShowAllAnnouncementsKey: false
			])
	}

	func setFilterEventFavorites(_ doFilterEventFavorites: Bool) {
		userDefaults.set(doFilterEventFavorites, forKey: UserDetailsNewsPreferences.NewsFilterEventFavoritesKey)
	}
	func setShowAllAnnouncements(_ doShowAllAnnouncements: Bool) {
		userDefaults.set(doShowAllAnnouncements, forKey: UserDetailsNewsPreferences.ShowAllAnnouncementsKey)
	}

}
