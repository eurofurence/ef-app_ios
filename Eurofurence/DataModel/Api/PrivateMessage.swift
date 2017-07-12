//
//  PrivateMessage.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class PrivateMessage: EntityBase {
	override class var DataModelVersion: Int { return 1 }
	
	var AuthorName: String = ""
	var CreatedDateTimeUtc: Date = Date()
	var Message: String = ""
	var ReadDateTimeUtc: Date = Date()
	var ReceivedDateTimeUtc: Date = Date()
	var RecipientUid: String = ""
	var Subject: String = ""
}
