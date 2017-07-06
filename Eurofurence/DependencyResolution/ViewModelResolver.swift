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
			try AnnouncementsViewModel(dataContext: ContextResolver.container.resolve())
		}
		_container.register(.singleton) {
			try CurrentEventsViewModel(dataContext: ContextResolver.container.resolve())
		}
		_container.register(.singleton) {
			try EventsViewModel(dataContext: ContextResolver.container.resolve())
		}
		_container.register(.singleton) {
			try MapViewModel(dataContext: ContextResolver.container.resolve())
		}
	}
}
