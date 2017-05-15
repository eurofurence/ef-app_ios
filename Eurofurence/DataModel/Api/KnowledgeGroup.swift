//
//  KnowledgeGroup.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class KnowledgeGroup: EntityBase {
	var Description : String = ""
	var FontAwesomeIconCharacter : String = ""
	var Name : String = ""
	var Order : Int = 0
	var ShowInHamburgerMenu : Bool = false
    
	var KnowledgeEntries : [KnowledgeEntry]? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
			keyInResource: String?)] {
		return [(keyInObject: "KnowledgeEntries",keyInResource: nil)]
	}
}

extension KnowledgeGroup : Comparable {
	static func < (lhs: KnowledgeGroup, rhs: KnowledgeGroup) -> Bool {
		return lhs.Order < rhs.Order
	}
}
