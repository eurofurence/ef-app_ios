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
	let TimeSinceLastSync = MutableProperty<TimeInterval>(-1.0)
	private let dataContext: DataContextProtocol
	private let lastSyncDateProvider: LastSyncDateProviding
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedAnnouncementsSignal: Signal<(Date, [Announcement]), NoError>
	private var disposable = CompositeDisposable()
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.AnnouncementsViewModelScheduler")

	init(dataContext: DataContextProtocol, lastSyncDateProvider: LastSyncDateProviding) {
		self.dataContext = dataContext
		self.lastSyncDateProvider = lastSyncDateProvider
		Announcements.swap(AnnouncementsViewModel.filterValidAnnouncements(timeService.currentTime.value, dataContext.Announcements.value))

		timedAnnouncementsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Announcements.signal).observe(on: scheduler)

		disposable += Announcements <~ timedAnnouncementsSignal.map(AnnouncementsViewModel.filterValidAnnouncements)

		disposable += TimeSinceLastSync <~ timeService.currentTime.signal.map({ [unowned self] currentTime in
			if let lastSyncDate = self.lastSyncDateProvider.lastSyncDate {
				return currentTime.timeIntervalSince(lastSyncDate)
			} else {
				return TimeInterval(-1.0)
			}
		})
	}

	private static func filterValidAnnouncements(_ time: Date, _ announcements: [Announcement]) -> [Announcement] {
		return announcements.filter({$0.ValidFromDateTimeUtc < time && $0.ValidUntilDateTimeUtc > time})
	}

	deinit {
		disposable.dispose()
	}
}
