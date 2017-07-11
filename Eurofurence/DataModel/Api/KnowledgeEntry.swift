//
//  KnowledgeEntry.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class KnowledgeEntry: EntityBase {
	/// Force reload if wrapped type LinkFragment changes
	override class var DataModelVersion: Int { return 2 + super.DataModelVersion + LinkFragment.DataModelVersion }

	var KnowledgeGroupId: String = ""
	var Order: Int = 0
	var Text: String = ""
	var Title: String = ""

	var ImageIds: [String] = []
	var Links: [LinkFragment] = []

	var Images: [Image]?
	weak var KnowledgeGroup: KnowledgeGroup?

	override public func propertyMapping() -> [(keyInObject: String?,
		keyInResource: String?)] {
			return [(keyInObject: "KnowledgeGroup", keyInResource: nil),
			        (keyInObject: "Images", keyInResource: nil)]
	}
}

extension KnowledgeEntry: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? KnowledgeEntry).map {
			return self.Order < $0.Order
			} ?? super.lessThan(rhs)
	}
}
