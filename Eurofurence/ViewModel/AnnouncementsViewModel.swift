//
//  AnnouncementsViewModel.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-06-06.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class AnnouncementsViewModel {
	let Announcements = MutableProperty<[Announcement]>([])
	private let dataContext: IDataContext
	private let timeService: TimeService = try! ServiceResolver.container.resolve()
	private var timedAnnouncementsSignal: Signal<(Date, [Announcement]), NoError>

	init(dataContext: IDataContext) {
		self.dataContext = dataContext
		timedAnnouncementsSignal = Signal.combineLatest(timeService.currentTime.signal, dataContext.Announcements.signal)

		Announcements <~ timedAnnouncementsSignal.map({ (time, events) in
			return events.filter({$0.ValidFromDateTimeUtc < time && $0.ValidUntilDateTimeUtc > time})
		})
	}
}