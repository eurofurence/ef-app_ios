//
//  WebApiConnection.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-16.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import EVReflection
import ReactiveSwift
import Alamofire

class WebApiConnection: IApiConnection {
	let apiUrl: URL
	let syncEndpoint: String

	// MARK: Initializers

	required convenience init?(_ apiUrlString: String, _ syncEndpoint: String) {
		guard let apiUrl = URL(string: apiUrlString) else {
			return nil
		}

		self.init(apiUrl, syncEndpoint)
	}

	required init(_ apiUrl: URL, _ syncEndpoint: String) {
		EVReflection.setDateFormatter(Iso8601DateFormatter())

		self.apiUrl = apiUrl
		self.syncEndpoint = syncEndpoint
	}

	// MARK: Custom API operations

	func doGetSync(parameters : Parameters? = nil) -> SignalProducer<Sync, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
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
			do {
				let json = try self.getJsonFromApi(endpointName: self.syncEndpoint)
			} catch let error as ApiConnectionError {
				observer.send(error: error)
			} catch let error {
				observer.send(error: ApiConnectionError.UnknownError(functionName: #function,
						description: error.localizedDescription))
			}
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
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

	private func getJsonFromApi(endpointName : String) throws -> EntityBase? {
		let getUrl = apiUrl.appendingPathComponent(endpointName)

		var parameters = ["since" : "0"]

		Alamofire.request(getUrl, method: .get, parameters: parameters)

		return nil
	}
}
