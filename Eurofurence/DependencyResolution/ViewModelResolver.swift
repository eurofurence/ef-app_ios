//
//  ViewModelResolver.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import Dip

/**
Dependency container with registered instances for all view models
*/
class ViewModelResolver {

	private static let instance = ViewModelResolver()
	/// Direct access to the wrapped DependencyContainer
	public static let container = ViewModelResolver.instance._container

	private let _container = DependencyContainer()

	private init() {
		_container.collaborate(with: ContextResolver.container)
		_container.register(.singleton) {
			AnnouncementsViewModel(dataContext: $0, lastSyncDateProvider: $1)
		}
		_container.register(.singleton) {
			CurrentEventsViewModel(dataContext: $0)
		}
		_container.register(.singleton) {
			EventsViewModel(dataContext: $0)
		}
		_container.register(.singleton) {
			MapViewModel(dataContext: $0)
		}
	}
}
