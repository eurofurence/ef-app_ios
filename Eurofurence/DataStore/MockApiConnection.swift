//
//  MockApiConnection.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 16.05.17.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import EVReflection

class MockApiConnection : IApiConnection {
	var apiUrl: String = ""
	var syncEndpoint: String = "Sync"
	
	required init(apiUrl: String, syncEndpoint: String) {
		EVReflection.setDateFormatter(Iso8601DateFormatter())
	}

	func doSyncGet(apiResponse: (NSDictionary?, NSError?) -> Void, progressHandler: IApiConnection.ProgressHandler?) {
		
		if let json = getJsonFromFile(endpoint: syncEndpoint) {
			apiResponse([syncEndpoint : Sync(json: json)], nil)
		} else {
			apiResponse(nil, NSError(domain: "EfApi", code: 404, userInfo: ["text" : "Sync endpoint not found!", "endpoint" : syncEndpoint, "apiUrl" : apiUrl]))
		}
	}
	
	func doEndpointGet(endpoint: String, apiResponse: (NSDictionary?, NSError?) -> Void, progressHandler: IApiConnection.ProgressHandler?) {
		
		if let json = getJsonFromFile(endpoint: endpoint), let entityType = getEntityType(name: endpoint) {
			apiResponse([endpoint : entityType.init(json: json)], nil)
		} else {
			apiResponse(nil, NSError(domain: "EfApi", code: 404, userInfo: ["text" : "Endpoint not found!", "endpoint" : endpoint, "apiUrl" : apiUrl]))
		}
	}
	
	func doEndpointPost(endpoint: String, apiResponse: (NSDictionary?, NSError?) -> Void, progressHandler: IApiConnection.ProgressHandler?) {
		
		apiResponse(nil, NSError(domain: "EfApi", code: 0, userInfo: ["text" : "Not implemented!"]))
	}
	
	private func getJsonFromFile(endpoint : String) -> String? {
		if let path = Bundle.main.path(forResource: endpoint + ".mock", ofType: "json"){
			do {
				return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
			}
			catch { }
		}
		return nil
	}
}
