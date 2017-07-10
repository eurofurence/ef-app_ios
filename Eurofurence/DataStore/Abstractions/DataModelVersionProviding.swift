//
//  DataModelVersionProviding.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

protocol DataModelVersionProviding {
	var dataModelVersions: [String:Int] {get}

	func getDataModelVersion(for entityName: String) -> Int?
	func setDataModelVersion(for entityName: String, version: Int) -> Bool
}
