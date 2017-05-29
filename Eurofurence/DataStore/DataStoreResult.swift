//
//  DataStoreResult.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-28.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation

class DataStoreResult {

	enum ResultType {
		case load
		case save
		case clear
		case clearAll
	}

	let resultType: ResultType
	let entityData: [EntityBase]?
	let entityType: EntityBase.Type?

	init(_ resultType: ResultType, entityType: EntityBase.Type? = nil, entityData: [EntityBase]? = nil) throws {

		switch (resultType) {
		case .load:
			guard entityType != nil && entityData != nil else {
				throw DataStoreError.InvalidParameter(functionName: #function, description: "entityType or entityData on .load")
			}
		case .save:
			guard entityType != nil && entityData == nil else {
				throw DataStoreError.InvalidParameter(functionName: #function, description: "entityType or entityData on .save")
			}
		case .clear:
			guard entityType != nil && entityData == nil else {
				throw DataStoreError.InvalidParameter(functionName: #function, description: "entityType or entityData on .clear")
			}
		case .clearAll:
			guard entityType == nil && entityData == nil else {
				throw DataStoreError.InvalidParameter(functionName: #function, description: "entityType or entityData on .clearAll")
			}
		}

		self.resultType = resultType
		self.entityData = entityData
		self.entityType = entityType
	}
}
