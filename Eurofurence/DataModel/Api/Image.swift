//
//  Image.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class Image: EntityBase {
	var ContentHashSha1 : String = ""
	var Height : Int = 0
	var InternalReference : String = ""
    var MimeType = ""
	var SizeInBytes : Int = 0
    var Title = ""
    var Url = ""
	var Width : Int = 0
	
	var Entities : [EntityBase] = []
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Entities",keyInResource: nil)]
	}
}
