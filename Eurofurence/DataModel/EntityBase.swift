//
//  EntityBase.swift
//  eurofurence
//
//  Created by Dominik Schöner on 2017-05-06.
//  Copyright © 2017 eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class EntityBase : EVObject {
    var Id : UUID = UUID()
    var LastChangeDateTimeUtc : Date = Date()
	
	var IsDeleted : Bool = false
	
	static func == (lhs: EntityBase, rhs: EntityBase) -> Bool {
		return lhs.Id == rhs.Id
	}
}
