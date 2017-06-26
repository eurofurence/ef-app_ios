//
//  KnowledgeGroup.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class KnowledgeGroup: EntityBase {
	var Description : String = ""
	var FontAwesomeIconCharacter : String = ""
	var Name : String = ""
	var Order : Int = 0
	var ShowInHamburgerMenu : Bool = false
    
	var KnowledgeEntries : [KnowledgeEntry] = []
	
	override public func propertyMapping() -> [(keyInObject: String?,
			keyInResource: String?)] {
		return [(keyInObject: "KnowledgeEntries", keyInResource: nil)]
	}
}

extension KnowledgeGroup: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? KnowledgeGroup).map {
			return self.Order < $0.Order
			} ?? super.lessThan(rhs)
	}
}
