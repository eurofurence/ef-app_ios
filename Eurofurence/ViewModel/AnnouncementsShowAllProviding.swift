//
//  AnnouncementsShowAllProviding.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol AnnouncementsShowAllProviding {
	var doShowAllAnnouncements: Bool { get }

	func setShowAllAnnouncements(_ doShowAllAnnouncements: Bool)
}
