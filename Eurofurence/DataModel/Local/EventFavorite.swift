//
//  EventFavorite.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift

class EventFavorite: EntityBase {
	var EventId: String = ""
	var IsFavorite: Bool = false

	required init() {
		super.init()
		self.Id = UUID().uuidString
	}

	convenience init(for event: Event) {
		self.init()
		self.EventId = event.Id
	}
}
