//
//  SimpleEventCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class SimpleEventCell: UITableViewCell {

	@IBOutlet weak var startTimeLabel: UILabel!
	@IBOutlet weak var endTimeLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!

	weak private var _event: Event?

	var event: Event? {
		get {
			return _event
		}
		set(event) {
			_event = event
			if let event = event {
				startTimeLabel.text = DateFormatters.hourMinute.string(from: event.StartDateTimeUtc)
				endTimeLabel.text = DateFormatters.hourMinute.string(from: event.EndDateTimeUtc)
			} else {
				startTimeLabel.text = nil
				endTimeLabel.text = nil
			}
			titleLabel.text = event?.Title
			subTitleLabel.text = event?.SubTitle
		}
	}
}
