//
//  Link.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class LinkFragment : EVObject {
	enum LinkFragmentType {
		case WebExternal
		case MapExternal
		case MapInternal
	}

	var FragmentType : LinkFragmentType = LinkFragmentType.WebExternal
	var Name : String = ""
	var Target : String = ""
}
