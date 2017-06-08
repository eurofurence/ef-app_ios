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
	static let defaultApiUrl = URL(string: "mock://api")!
	let apiUrl: URL = defaultApiUrl
	let syncEndpoint: String = "Sync"

	// MARK: Initializers

	required convenience init?(_ apiUrlString: String = "", _ syncEndpoint: String = "") {
		self.init(MockApiConnection.defaultApiUrl, syncEndpoint)
	}

	required init( _ apiUrl: URL, _ syncEndpoint: String) {
		EVReflection.setDateFormatter(Iso8601DateFormatter())
	}

	// MARK: Custom API operations

	func doGetSync(parameters : Parameters? = nil) -> SignalProducer<Sync, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			if let json = self.getJsonFromFile(self.syncEndpoint) {
				observer.send(value: Sync(json: json))
				observer.sendCompleted()
			} else {
				observer.send(error: ApiConnectionError.NotFound(entityType: self.syncEndpoint,
						description: "No JSON file named \(self.syncEndpoint).mock could be found."))
			}
		}
	}

	func doGetAnnouncements(by id : String) -> SignalProducer<Announcement, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	func doGetImageContent(by id : String) -> SignalProducer<UIImage, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	// MARK: General HTTP verbs

	func doGet(_ endpoint : String, parameters : Parameters? = nil) -> SignalProducer<EVObject, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			if let json = self.getJsonFromFile(endpoint),
			   let entityType = self.getEntityType(name: endpoint) {
				observer.send(value: entityType.init(json: json))
				observer.sendCompleted()
			} else {
				observer.send(error: ApiConnectionError.NotFound(entityType: endpoint,
						description: "No JSON file named \(endpoint).mock could be found."))
			}
		}
	}

	func doPost(_ endpoint : String, payload : EVReflectable? = nil, parameters : Parameters? = nil) -> SignalProducer<EVObject, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	func doPut(_ endpoint : String, payload : EVReflectable? = nil, parameters : Parameters? = nil) -> SignalProducer<EVObject, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	func doDelete(_ endpoint : String, parameters : Parameters? = nil) -> SignalProducer<EVObject, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	// MARK: Internal implementation
	
	private func getJsonFromFile(_ endpoint : String) -> String? {
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
