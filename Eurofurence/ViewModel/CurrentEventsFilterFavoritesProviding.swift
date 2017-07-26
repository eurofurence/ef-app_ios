//
//  CurrentEventsFilterFavoritesProviding.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol CurrentEventsFilterFavoritesProviding {
	var doFilterEventFavorites: Bool { get }

	func setFilterEventFavorites(_ doFilterEventFavorites: Bool)
}
