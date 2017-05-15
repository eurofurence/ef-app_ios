//
//  KnowledgeEntry.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation

class KnowledgeEntry: EntityBase {
	var KnowledgeGroupId : UUID = UUID()
	var Order : Int = 0
	var Text : String = ""
	var Title : String = ""
    
	var Links : [LinkFragment] = []
    
    var KnowledgeGroup : KnowledgeGroup? = nil
}

extension KnowledgeEntry : Comparable {
	static func < (lhs: KnowledgeEntry, rhs: KnowledgeEntry) -> Bool {
		return lhs.Order < rhs.Order
	}
}
