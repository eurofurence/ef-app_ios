//
//  MapEntry.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

class MapEntry: EntityBase {
    var RelativeTapRadius = 0.0
    var RelativeX = 0.0
    var RelativeY = 0.0
	var Link : LinkFragment = LinkFragment()
	
	var Map : Map? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "Map",keyInResource: nil)]
	}
}

extension MapEntry {
	func getAbsoluteLocationForImage(_ image: UIImage) -> CGPoint {
		return CGPoint(x: CGFloat(RelativeX/100) * image.size.width, y: CGFloat(RelativeY/100) * image.size.height)
	}
	
	func getAbsoluteTapRadiusForImage(_ image: UIImage) -> CGFloat {
		return CGFloat(RelativeTapRadius) * image.size.height
	}
}
