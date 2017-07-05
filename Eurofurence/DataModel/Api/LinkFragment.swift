//
//  Link.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class LinkFragment: EVObject {
	enum LinkFragmentType: String, EVRaw {
		case DealerDetail
		case MapExternal
		case MapInternal
		case WebExternal
	}

	var FragmentType: LinkFragmentType = LinkFragmentType.WebExternal
	var Name: String = ""
	var Target: String = ""
	
	weak var TargetObject: AnyObject? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "TargetObject", keyInResource: nil)]
	}
	
	override func setValue(_ value: Any!, forUndefinedKey key: String) {
		switch key {
		case "FragmentType":
			if let rawValue = value as? String {
				if let status =  LinkFragmentType(rawValue: rawValue) {
					self.FragmentType = status
				}
			}
		default:
			self.addStatusMessage(.IncorrectKey, message: "SetValue for key '\(key)' should be handled.")
			print("---> setValue for key '\(key)' should be handled.")
		}
	}
}

extension LinkFragment {
	func getTarget<T>() -> T? {
		switch FragmentType {
		case .WebExternal:
			return URL(string: Target) as? T
		default:
			return TargetObject as? T
		}
	}
}
