//
//  EventCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventSubNameLabel: UILabel!
    @IBOutlet weak var eventDurationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventRoomLabel: UILabel!
    @IBOutlet weak var eventDayLabel: UILabel!
    @IBOutlet weak var eventDayLabelHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var eventSubNameLabelHeightConstraint: NSLayoutConstraint!
	
	weak private var _event: Event?
	
	var event: Event? {
		get {
			return _event
		}
		set(event) {
			_event = event
			
			if let conferenceDay = event?.ConferenceDay/*, searchController.isActive && searchController.searchBar.text != ""*/ {
				eventDayLabel.isHidden = false;
				eventDayLabel.text = "\(conferenceDay.Name) – \(DateFormatters.dayMonthLong.string(from: conferenceDay.Date))"
				
				if eventDayLabelHeightConstraint != nil {
					eventDayLabelHeightConstraint!.isActive = false
				}
			}
			eventNameLabel.text = event?.Title
			
			if let subTitle = event?.SubTitle, !subTitle.isEmpty {
				if eventSubNameLabelHeightConstraint != nil {
					eventSubNameLabelHeightConstraint!.isActive = false
				}
				eventSubNameLabel.text = subTitle
			} else {
				if eventSubNameLabelHeightConstraint != nil {
					eventSubNameLabelHeightConstraint!.isActive = true
				} else {
					eventSubNameLabelHeightConstraint = NSLayoutConstraint(item: eventSubNameLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 0)
					addConstraint(eventSubNameLabelHeightConstraint!)
				}
			}
			
			if let startDateTimeUtc = event?.StartDateTimeUtc {
				eventDateLabel.text = "Starting at \(DateFormatters.hourMinute.string(from: startDateTimeUtc))"
			} else {
				eventDateLabel.text = nil
			}
			
			if let roomName = event?.ConferenceRoom?.Name {
				eventRoomLabel.text = "in \(roomName)"
			} else {
				eventRoomLabel.text = "n/a"
			}
			let durationHours = ((event?.Duration ?? 0) / 60 / 60)
			let durationMinutes = ((event?.Duration ?? 0) / 60 % 60)
			if durationHours == 0 && durationMinutes == 0 {
				eventDurationLabel.text = "n/a"
			} else {
				eventDurationLabel.text = "for \(durationHours) hour\(durationHours == 1 ? "" : "s") \(durationMinutes) minute\(durationMinutes == 1 ? "" : "s")"
			}
			accessoryType = UITableViewCellAccessoryType.disclosureIndicator
			if let isDeviatingFromConBook = event?.IsDeviatingFromConBook, isDeviatingFromConBook {
				eventDateLabel.textColor = UIColor.orange
				eventDateLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
			} else {
				eventDateLabel.textColor = UIColor.white
				eventDateLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
			}
			tintColor = UIColor.white
		}
	}
}
