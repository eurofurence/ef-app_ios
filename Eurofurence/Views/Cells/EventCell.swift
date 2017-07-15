//
//  EventCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit
import ReactiveSwift

class EventCell: UITableViewCell {

	@IBOutlet weak var bannerImageView: UIImageView!
	@IBOutlet weak var endTimeLabel: UILabel!
	@IBOutlet weak var favoriteLabel: UILabel!
	@IBOutlet weak var startTimeLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!

	var defaultHeightConstraint: NSLayoutConstraint!
	var zeroHeightConstraint: NSLayoutConstraint!

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
					favoriteLabel.reactive.isHidden <~ eventFavorite.IsFavorite.map({ !$0 })
				} else {
					favoriteLabel.isHidden = true
				}
				if let _ = event.BannerImage {
					zeroHeightConstraint.isActive = false
					defaultHeightConstraint.isActive = true
					bannerImageView.updateConstraints()
				} else {
					zeroHeightConstraint.isActive = true
					defaultHeightConstraint.isActive = false
					bannerImageView.updateConstraints()
				}
			} else {
				startTimeLabel.text = nil
				endTimeLabel.text = nil
			}
			titleLabel.text = event?.Title
			subTitleLabel.text = event?.SubTitle
		}
	}

	override func awakeFromNib() {
		bannerImageView.constraints.forEach({ (constraint) in
			if constraint.identifier == "HeightConstraint" {
				self.defaultHeightConstraint = constraint
			}
		})
		zeroHeightConstraint = NSLayoutConstraint(item: bannerImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 0)
		zeroHeightConstraint?.isActive = false
		bannerImageView.addConstraint(zeroHeightConstraint)
	}

	func toggleFavorite(button: UIButton) {
		button.isSelected = !button.isSelected
		if let eventFavorite = event?.EventFavorite {
			eventFavorite.IsFavorite.swap(button.isSelected)
		}
	}
}
