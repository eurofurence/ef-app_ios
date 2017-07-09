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

		BrowsableMaps.swap(MapViewModel.filterBrowsableMaps(dataContext.Maps.value))

		disposable += BrowsableMaps <~ dataContext.Maps.signal
			.map(MapViewModel.filterBrowsableMaps)
	}

	static private func filterBrowsableMaps(_ maps: [Map]) -> [Map] {
		return maps.filter({ return $0.IsBrowseable && $0.Image != nil })
	}

	deinit {
		disposable.dispose()
	}
}
