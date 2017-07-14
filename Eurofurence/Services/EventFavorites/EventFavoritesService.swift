//
//  EventFavoritesService.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift

class EventFavoritesService {
	private let dataContext: DataContextProtocol
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.EventFavoritesService")
	private var disposables = CompositeDisposable()
	private var eventFavoriteDisposbales = CompositeDisposable()

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext

		disposables += dataContext.EventFavorites.signal.observeValues({
			[unowned self] (eventFavorites) in
			self.observe(eventFavorites)
		})
	}

	private func observe(_ eventFavorites: [EventFavorite]) {
		eventFavoriteDisposbales.dispose()
		eventFavoriteDisposbales = CompositeDisposable()
		eventFavorites.forEach({ (eventFavorite) in
			eventFavoriteDisposbales += eventFavorite.IsFavorite.signal.observeValues({ [unowned self] _ in
				print("EventFavorites changed!")
				self.eventFavoriteDisposbales += self.dataContext.saveToStore(.Events).start()
			})
		})
	}

	deinit {
		disposables.dispose()
		eventFavoriteDisposbales.dispose()
	}
}
