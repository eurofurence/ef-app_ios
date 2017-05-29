//
//  MockApiConnection.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-16.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import EVReflection
import ReactiveSwift
import Alamofire

class MockApiConnection : IApiConnection {
	fileprivate let apiUrl: String = "mock://api"
	fileprivate let syncEndpoint: String = "Sync"

	private(set) lazy var syncGet: SignalProducer<Sync, NSError> =
			SignalProducer { observer, disposable in
				if let json = self.getJsonFromFile(endpoint: self.syncEndpoint) {
					observer.send(value: Sync(json: json))
					observer.sendCompleted()
				} else {
					observer.send(error: NSError(domain: "EfApi", code: 404, userInfo:
					["text": "Sync endpoint not found!", "endpoint": self.syncEndpoint,
					 "apiUrl": self.apiUrl]))
				}
			}


	private(set) lazy var endpointGet: Action<String, EntityBase, NSError> =
			Action { endpoint in
				return SignalProducer { observer, disposable in
					if let json = self.getJsonFromFile(endpoint: endpoint),
					   let entityType = self.getEntityType(name: endpoint) {
						observer.send(value: entityType.init(json: json))
						observer.sendCompleted()
					} else {
						observer.send(error: NSError(domain: "EfApi", code: 404, userInfo:
						["text": "Endpoint not found!", "endpoint": endpoint,
						 "apiUrl": self.apiUrl]))
					}
				}
			}

	private(set) lazy var endpointPost: Action<(String, EVReflectable?), EntityBase, NSError> =
			Action { (endpoint, payload) in
				return SignalProducer { observer, disposable in
					observer.send(error: NSError(domain: "EfApi", code: 0, userInfo:
					["text": "Not Implemented!"]))
				}
			}

	required init(apiUrl: String, syncEndpoint: String) {
		EVReflection.setDateFormatter(Iso8601DateFormatter())
	}
	
	private func getJsonFromFile(endpoint : String) -> String? {
		if let path = Bundle.main.path(forResource: endpoint + ".mock", ofType: "json"){
			do {
				return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
			} catch {
				/* nothing to handle, either there is data or there is nil */
			}
		}
		return nil
	}
}
