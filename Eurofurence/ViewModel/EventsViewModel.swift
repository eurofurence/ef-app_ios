//
//  EventsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class EventsViewModel {
	let Events = MutableProperty<[Event]>([])
	let EventConferenceDays = MutableProperty<[EventConferenceDay]>([])
	let EventConferenceRooms = MutableProperty<[EventConferenceRoom]>([])
	let EventConferenceTracks = MutableProperty<[EventConferenceTrack]>([])
	private let dataContext: DataContextProtocol
	private var disposable = CompositeDisposable()

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext

		disposable += Events <~ dataContext.Events

		disposable += EventConferenceDays <~ dataContext.EventConferenceDays

		disposable += EventConferenceRooms <~ dataContext.EventConferenceRooms

		disposable += EventConferenceTracks <~ dataContext.EventConferenceTracks
	}

	deinit {
		disposable.dispose()
	}
}
