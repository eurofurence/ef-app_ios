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
	var IsFavorite: MutableProperty<Bool> = MutableProperty(false)
	
	weak var Event: Event?

	required init() {
		super.init()
		self.Id = UUID().uuidString
	}

	convenience init(for event: Event) {
		self.init()
		self.EventId = event.Id
	}

	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Event", keyInResource: nil)]
	}
	
	override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> Void), encodeConverter: (() -> Any?))] {
		return [
			(key: "IsFavorite",
			 decodeConverter: { self.IsFavorite.swap(($0 as? Bool) ?? false) },
			 encodeConverter: { return self.IsFavorite.value })
		]
	}
}
