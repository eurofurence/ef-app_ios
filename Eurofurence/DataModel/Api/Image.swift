//
//  Image.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import CoreGraphics

class Image: EntityBase {
	var ContentHashSha1: String = ""
	var Height: Int = 0
	var InternalReference: String = ""
    var MimeType = ""
	var SizeInBytes: Int = 0
    var Width: Int = 0

	var Entities: [EntityBase] = []

	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Entities", keyInResource: nil)]
	}
}

extension Image {
	var CGSize: CoreGraphics.CGSize { get { return CoreGraphics.CGSize(width: Width, height: Height) } }
	var CGHeight: CGFloat { get { return CGFloat(Height) } }
	var CGWidth: CGFloat { get { return CGFloat(Width) } }
}
