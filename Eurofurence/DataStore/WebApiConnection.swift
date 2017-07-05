//
//  WebApiConnection.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import EVReflection
import ReactiveSwift
import Alamofire

class WebApiConnection: ApiConnectionProtocol {

	let scheduler = QueueScheduler(qos: .userInitiated, name: "org.eurofurence.app.WebApiScheduler")
	let apiUrl: URL

	required convenience init?(_ apiUrlString: String) {
		guard let apiUrl = URL(string: apiUrlString) else {
			return nil
		}

		self.init(apiUrl)
	}

	required init(_ apiUrl: URL) {
		EVReflection.setDateFormatter(Iso8601DateFormatter())
		self.apiUrl = apiUrl
	}

	func doGet<EntityType: EVNetworkingObject>(_ endpoint: String, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, _ in
			let getUrl = self.apiUrl.appendingPathComponent(endpoint)
			print("Retrieving \(getUrl) from API via GET using parameters \(String(describing: parameters)).")
			Alamofire.request(getUrl, method: .get, parameters: parameters).responseObject(completionHandler: {
				(response: DataResponse<EntityType>) in
				if let result = response.value {
					observer.send(value: result)
					observer.sendCompleted()
					print("Successfully retrieved \(getUrl) from API via GET using parameters \(String(describing: parameters)).")
				} else if let error = response.error {
					observer.send(error: ApiConnectionError.HttpError(endpoint: endpoint, verb: #function,
					                                                  description: error.localizedDescription))
					print("Failed to retrieve \(getUrl) from API via GET using parameters \(String(describing: parameters)): \(error.localizedDescription)")
				} else {
					observer.send(error: ApiConnectionError.UnknownError(functionName: #function,
							description: nil))
					print("Failed to retrieve \(getUrl) from API via GET using parameters \(String(describing: parameters)).")
				}
			})
		}.observe(on: scheduler)
	}

	func doPost<EntityType: EVNetworkingObject>(_ endpoint: String, payload: EVReflectable? = nil, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, _ in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}.observe(on: scheduler)
	}

	func doPut<EntityType: EVNetworkingObject>(_ endpoint: String, payload: EVReflectable? = nil, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, _ in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}.observe(on: scheduler)
	}

	func doDelete<EntityType: EVNetworkingObject>(_ endpoint: String, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, _ in
			observer.send(error: ApiConnectionError.NotImplemented(functionName: #function))
		}.observe(on: scheduler)
	}
}
