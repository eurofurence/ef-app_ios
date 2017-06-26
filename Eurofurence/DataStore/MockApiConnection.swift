//
//  MockApiConnection.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection
import ReactiveSwift
import Alamofire

class MockApiConnection: IApiConnection {
	static let defaultApiUrl = URL(string: "mock://api")!
	let apiUrl: URL = defaultApiUrl

	// MARK: Initializers

	required convenience init?(_ apiUrlString: String = "") {
		self.init(MockApiConnection.defaultApiUrl)
	}

	required init(_ apiUrl: URL) {
		EVReflection.setDateFormatter(Iso8601DateFormatter())
	}

	// MARK: General HTTP verbs

	func doGet<EntityType:EVNetworkingObject>(_ endpoint: String, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			if let json = self.getJsonFromFile(endpoint) {
				observer.send(value: EntityType.init(json: json))
				observer.sendCompleted()
			} else {
				observer.send(error: ApiConnectionError.NotFound(entityType: endpoint,
						description: "No JSON file named \(endpoint).mock could be found."))
			}
		}
	}

	func doPost<EntityType:EVNetworkingObject>(_ endpoint: String, payload: EVReflectable? = nil, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	func doPut<EntityType:EVNetworkingObject>(_ endpoint: String, payload: EVReflectable? = nil, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	func doDelete<EntityType:EVNetworkingObject>(_ endpoint: String, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}
	}

	// MARK: Internal implementation

	private func getJsonFromFile(_ endpoint: String) -> String? {
		if let path = Bundle.main.path(forResource: endpoint + ".mock", ofType: "json") {
			do {
				return try String(contentsOfFile: path, encoding: String.Encoding.utf8)
			} catch {
				/* nothing to handle, either there is data or there is nil */
			}
		}
		return nil
	}
}
