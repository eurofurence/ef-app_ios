//
//  KnowledgeGroup.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class KnowledgeGroup: EntityBase {
	var Description: String = ""
	var FontAwesomeIconCharacterUnicodeAddress: String = ""
	var Name: String = ""
	var Order: Int = 0
	var ShowInHamburgerMenu: Bool = false

	var KnowledgeEntries: [KnowledgeEntry] = []

	override public func propertyMapping() -> [(keyInObject: String?,
			keyInResource: String?)] {
		return [(keyInObject: "KnowledgeEntries", keyInResource: nil)]
	}

	override func propertyConverters() -> [(key: String, decodeConverter: ((Any?) -> Void), encodeConverter: (() -> Any?))] {
		return [
			(key: "FontAwesomeIconCharacterUnicodeAddress",
			 decodeConverter: {
				guard let value = $0 as? String, let character = Character.init(unicodeScalarString: value) else { return }
				self.FontAwesomeIconCharacterUnicodeAddress = String.init(character) },
			 encodeConverter: {
				return String(format:"%X", self.FontAwesomeIconCharacterUnicodeAddress.unicodeScalars.first?.value ?? 0)
			})
		]
	}
}

extension KnowledgeGroup: Sortable {
	override public func lessThan(_ rhs: EntityBase) -> Bool {
		return (rhs as? KnowledgeGroup).map {
			return self.Order < $0.Order
			} ?? super.lessThan(rhs)
	}
}
