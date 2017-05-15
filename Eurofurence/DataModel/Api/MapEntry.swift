//
//  MapEntry.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class MapEntry: EntityBase {
    var MapId = ""
    var MarkerType = ""
    var RelativeTapRadius = 0.0
    var RelativeX = 0.0
    var RelativeY = 0.0
    var TargetDescription: String?
    var TargetId = ""
    
	let Map : Map? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Map",keyInResource: nil)]
	}
}
