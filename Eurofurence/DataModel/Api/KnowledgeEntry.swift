//
//  KnowledgeEntry.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class KnowledgeEntry: EntityBase {
	var KnowledgeGroupId : String = ""
	var Order : Int = 0
	var Text : String = ""
	var Title : String = ""
    
	var Links : [LinkFragment] = []
    
	var KnowledgeGroup : KnowledgeGroup? = nil
	
	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "KnowledgeGroup",keyInResource: nil)]
	}
}

extension KnowledgeEntry : Comparable {
	static func < (lhs: KnowledgeEntry, rhs: KnowledgeEntry) -> Bool {
		return lhs.Order < rhs.Order
	}
}
