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
	fileprivate var apiUrl: String
	fileprivate var syncEndpoint: String

	private(set) lazy var syncGet: SignalProducer<Sync, NSError> =
			SignalProducer { observer, disposable in
				observer.send(error: NSError(domain: "EfApi", code: 0, userInfo:
				["text": "Not Implemented!"]))
			}

	private(set) lazy var endpointGet: Action<String, EntityBase, NSError> =
			Action { endpoint in
				return SignalProducer { observer, disposable in
					observer.send(error: NSError(domain: "EfApi", code: 0, userInfo:
					["text": "Not Implemented!"]))
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

		self.apiUrl = apiUrl
		self.syncEndpoint = syncEndpoint
	}
}
