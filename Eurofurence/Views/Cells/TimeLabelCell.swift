//
//  TimeLabelCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class TimeLabelCell: UITableViewCell {

	@IBOutlet weak var timeLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()

		timeLabel.text = "Wednesday, 15:03"
	}
}
