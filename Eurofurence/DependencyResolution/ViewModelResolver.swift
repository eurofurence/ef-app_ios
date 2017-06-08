//
//  ViewModelResolver.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-05-20.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
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
		_container.register(.singleton) {
			try AnnouncementsViewModel(dataContext: ContextResolver.container.resolve())
		}
	}
}