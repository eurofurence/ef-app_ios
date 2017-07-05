//
//  AnnouncementsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class AnnouncementsViewModel {
	let Announcements = MutableProperty<[Announcement]>([])
	private let dataContext: DataContextProtocol
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedAnnouncementsSignal: Signal<(Date, [Announcement]), NoError>
	private var disposable = CompositeDisposable()
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.AnnouncementsViewModelScheduler")

	init(dataContext: DataContextProtocol) {
		self.dataContext = dataContext
		timedAnnouncementsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Announcements.signal).observe(on: scheduler)

		disposable += Announcements <~ timedAnnouncementsSignal.map({ (time, items) in
			return items.filter({$0.ValidFromDateTimeUtc < time && $0.ValidUntilDateTimeUtc > time})
		})
	}
	
	deinit {
		disposable.dispose()
	}
}
