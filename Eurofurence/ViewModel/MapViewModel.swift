//
//  MapViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift

class MapViewModel {
	let BrowsableMaps = MutableProperty<[Map]>([])

	private let dataContext: DataContextProtocol
	private var disposable = CompositeDisposable()

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext

		disposable += BrowsableMaps <~ dataContext.Maps.signal
			.map({ return $0.filter({ return $0.IsBrowseable && $0.Image != nil })})
	}

	deinit {
		disposable.dispose()
	}
}
