//
//  Map.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class Map: EntityBase {
    var Description = ""
    var ImageId = ""
    var IsBrowseable = true
    
    var Image : Image? = nil
	var MapEntries : [MapEntry]? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Image",keyInResource: nil),
			        (keyInObject: "MapEntries",keyInResource: nil)]
	}
}
