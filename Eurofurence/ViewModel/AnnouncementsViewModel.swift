//
//  AnnouncementsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import Changeset
import ReactiveSwift
import Result

class AnnouncementsViewModel {
	let Announcements = MutableProperty<[Announcement]>([])
	let AnnouncementsEdits = MutableProperty<[Edit<Announcement>]>([])
	let TimeSinceLastSync = MutableProperty<TimeInterval>(-1.0)
	private let dataContext: DataContextProtocol
	private let lastSyncDateProvider: LastSyncDateProviding
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedAnnouncementsSignal: Signal<(Date, [Announcement]), NoError>
	private var disposable = CompositeDisposable()
	private let scheduler = QueueScheduler(qos: .background, name: "org.eurofurence.app.AnnouncementsViewModelScheduler")

	var isShowAll: Bool = false

	init(dataContext: DataContextProtocol, lastSyncDateProvider: LastSyncDateProviding) {
		self.dataContext = dataContext
		self.lastSyncDateProvider = lastSyncDateProvider

		timedAnnouncementsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Announcements.signal).observe(on: scheduler)
		Announcements.swap(filterValidAnnouncements(timeService.currentTime.value, dataContext.Announcements.value))
		AnnouncementsEdits.swap(Changeset.edits(from: [], to: Announcements.value))

		disposable += Announcements <~ timedAnnouncementsSignal.map(filterValidAnnouncements)
			.skipRepeats({ $0.count == $1.count && $0.starts(with: $1)})

		disposable += AnnouncementsEdits <~ Announcements.combinePrevious(Announcements.value)
			.map({ (oldAnnouncements, newAnnouncements) in
			return Changeset.edits(from: oldAnnouncements, to: newAnnouncements)
		})

		disposable += TimeSinceLastSync <~ timeService.currentTime.signal.map({ [unowned self] currentTime in
			if let lastSyncDate = self.lastSyncDateProvider.lastSyncDate {
				return currentTime.timeIntervalSince(lastSyncDate)
			} else {
				return TimeInterval(-1.0)
			}
		})
	}

	private func filterValidAnnouncements(_ time: Date, _ announcements: [Announcement]) -> [Announcement] {
		return announcements.filter({$0.ValidFromDateTimeUtc < time && $0.ValidUntilDateTimeUtc > time && (self.isShowAll || !$0.IsRead)})
	}

	deinit {
		disposable.dispose()
	}
}
