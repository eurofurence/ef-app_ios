//
//  AnnouncementsViewModel.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-06-06.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import Foundation
import ReactiveSwift

class AnnouncementsViewModel {
	let Announcements = MutableProperty<[Announcement]>([])
	let dataContext: IDataContext

	init(dataContext: IDataContext) {
		self.dataContext = dataContext

		Announcements <~ dataContext.Announcements
	}
}