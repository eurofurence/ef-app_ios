//
//  MapEntry.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class MapEntry: EntityBase {
    var TapRadius = 0.0
    var X = 0.0
    var Y = 0.0
	var Links: [LinkFragment] = []

	weak var Map: Map?

	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Map", keyInResource: nil)]
	}
}
