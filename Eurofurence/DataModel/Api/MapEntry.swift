//
//  MapEntry.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import CoreGraphics

class MapEntry: EntityBase {
	/// Force reload if wrapped type LinkFragment changes
	override class var DataModelVersion: Int { return 1 + super.DataModelVersion + LinkFragment.DataModelVersion }

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

extension MapEntry {
	var CGLocation: CGPoint { get { return CGPoint(x: X, y: Y) } }
	var CGTapRadius: CGFloat { get { return CGFloat(TapRadius) } }
	var CGX: CGFloat { get { return CGFloat(X) } }
	var CGY: CGFloat { get { return CGFloat(Y) } }
}
