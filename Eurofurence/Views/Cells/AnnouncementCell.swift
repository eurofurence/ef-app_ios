//
//  AnnouncementCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class AnnouncementCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

	weak private var _announcement: Announcement?

	var announcement: Announcement? {
		get {
			return _announcement
		}
		set(announcement) {
			_announcement = announcement

			titleLabel.text = announcement?.Title
			descLabel.text = announcement?.Content
		}
	}

}
