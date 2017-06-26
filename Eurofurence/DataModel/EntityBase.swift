//
//  EntityBase.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection

class EntityBase : EVObject, Comparable {
    var Id : String = ""
    var LastChangeDateTimeUtc : Date = Date()
	
	var IsDeleted : Bool = false
	
	static func == (lhs: EntityBase, rhs: EntityBase) -> Bool {
		return lhs.equalTo(rhs)
	}
	
	public dynamic func equalTo(_ rhs: EntityBase) -> Bool {
		return self.Id == rhs.Id
	}
	
	static func < (lhs: EntityBase, rhs: EntityBase) -> Bool {
		return lhs.lessThan(rhs)
	}
	
	public dynamic func lessThan(_ rhs: EntityBase) -> Bool {
		return self.Id < rhs.Id
	}

	override public func propertyMapping() -> [(keyInObject: String?,
	                                            keyInResource: String?)] {
		return [(keyInObject: "IsDeleted", keyInResource: nil)]
	}
}

protocol Sortable {}
