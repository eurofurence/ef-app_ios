//
//  Link.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class LinkFragment : EVObject {
	enum LinkFragmentType : String, EVRaw {
		case WebExternal
		case MapExternal
		case MapInternal
	}

	var FragmentType : LinkFragmentType = LinkFragmentType.WebExternal
	var Name : String = ""
	var Target : String = ""
	
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
