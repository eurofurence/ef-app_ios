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

	func doGet<EntityType:EVNetworkingObject>(_ endpoint: String, parameters: Parameters? = nil) -> SignalProducer<EntityType, ApiConnectionError> {
		return SignalProducer { observer, disposable in
			let getUrl = self.apiUrl.appendingPathComponent(endpoint)
			Alamofire.request(getUrl, method: .get, parameters: parameters).responseObject(completionHandler: {
				(response: DataResponse<EntityType>) in
				if let result = response.value {
					observer.send(value: result)
					observer.sendCompleted()
				} else if let error = response.error {
					observer.send(error: ApiConnectionError.HttpError(endpoint: endpoint, verb: #function,
							description: error.localizedDescription))
				} else {
					observer.send(error: ApiConnectionError.UnknownError(functionName: #function,
							description: nil))
				}
			})
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
}
