//
//  ContextResolver.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import Dip

/**
Dependency container with registered instances for all data contexts and related classes
*/
class ContextResolver {

	private static let instance = ContextResolver()
	/// Direct access to the wrapped DependencyContainer
	public static let container = ContextResolver.instance._container

	private let _container = DependencyContainer()

	private init() {
		#if OFFLINE
			_container.register(.singleton) { _ in
				MockApiConnection("mock://api")! as ApiConnectionProtocol
			}
		#else
			_container.register(.singleton) { _ in
				WebApiConnection(URL(string: "https://app.eurofurence.org/api/v2/")!) as ApiConnectionProtocol
			}
		#endif

		_container.register(.singleton) {
			JsonDataStore() as DataStoreProtocol
		}
		_container.register(.singleton) {
			NavigationResolver() as NavigationResolverProtocol
		}

		_container.register(.singleton) {
			ReactiveDataContext(dataStore: $0, navigationResolver: $1) as DataContextProtocol
		}

		_container.register(.singleton) {
			ContextManager(apiConnection: $0,
			                   dataContext: $1,
			                   dataStore: $2,
			                   imageService: $3)
		}
	}
}
