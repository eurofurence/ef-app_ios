//
//  TimeLabelCell.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-07-17.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import UIKit

class TimeLabelCell: UITableViewCell {
	
	@IBOutlet weak var timeLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		timeLabel.text = "Wednesday, 15:03"
	}
}
