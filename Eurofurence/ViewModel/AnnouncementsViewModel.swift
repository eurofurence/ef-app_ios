//
//  AnnouncementsViewModel.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Changeset

class AnnouncementsViewModel {
	let Announcements = MutableProperty<[Announcement]>([])
	let AnnouncementsEdits = MutableProperty<[Edit<Announcement>]>([])
	private let dataContext: IDataContext
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedAnnouncementsSignal: Signal<(Date, [Announcement]), NoError>
	private var disposable = CompositeDisposable()

	init(dataContext: IDataContext) {
		self.dataContext = dataContext
		timedAnnouncementsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Announcements.signal)

		disposable += Announcements <~ timedAnnouncementsSignal.map({ (time, items) in
			return items.filter({$0.ValidFromDateTimeUtc < time && $0.ValidUntilDateTimeUtc > time})
		})
	}
	
	deinit {
		disposable.dispose()
	}
}
