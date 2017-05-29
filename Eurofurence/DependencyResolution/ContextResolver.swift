//
//  ContextResolver.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-20.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import Dip

enum Environment: String, DependencyTagConvertible {
	case Production
	case Development
}

class ContextResolver {

	private static let instance = ContextResolver()
	public static let container = ContextResolver.instance._container

	private let _container = DependencyContainer()

	private init() {
		_container.register(.singleton, tag: Environment.Development) { apiUrl in
			MockApiConnection(apiUrl: "", syncEndpoint: "") as IApiConnection
		}
		_container.register(.singleton, tag: Environment.Production) { apiUrl in
			WebApiConnection(apiUrl: "https://app.eurofurence.org/api/v2/", syncEndpoint: "Sync") as IApiConnection
		}

		_container.register(.singleton) {
			JsonDataStore() as IDataStore
		}
		_container.register(.singleton) {
			NavigationResolver() as INavigationResolver
		}

		_container.register(.singleton) {
			ReactiveDataContext(dataStore: $0, navigationResolver: $1) as IDataContext
		}

		_container.register(.singleton) {
			ContextManager(apiConnection: $0, dataContext: $1, dataStore: $2)
		}
	}
}
