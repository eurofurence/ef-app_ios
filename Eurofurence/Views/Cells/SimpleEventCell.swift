//
//  SimpleEventCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift

class SimpleEventCell: UITableViewCell {

	@IBOutlet weak var endTimeLabel: UILabel!
	@IBOutlet weak var favoriteButton: UIButton!
	@IBOutlet weak var startTimeLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!

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
				if let eventFavorite = event.EventFavorite {
					favoriteButton.addTarget(self, action: #selector(toggleFavorite(button:)), for: .touchUpInside)
					favoriteButton.reactive.isSelected <~ eventFavorite.IsFavorite
				}
			} else {
				startTimeLabel.text = nil
				endTimeLabel.text = nil
			}
			titleLabel.text = event?.Title
			subTitleLabel.text = event?.SubTitle
		}
	}

	func toggleFavorite(button: UIButton) {
		button.isSelected = !button.isSelected
		if let eventFavorite = event?.EventFavorite {
			eventFavorite.IsFavorite.swap(button.isSelected)
		}
	}
}
