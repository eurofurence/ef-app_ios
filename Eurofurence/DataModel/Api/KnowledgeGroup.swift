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
}
