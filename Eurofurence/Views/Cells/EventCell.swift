//
//  EventCell.swift
//  Eurofurence
//
//  Created by Dominik Schöner on 2017-07-17.
//  Copyright © 2017 Dominik Schöner. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
	
	@IBOutlet weak var startTimeLabel: UILabel!
	@IBOutlet weak var endTimeLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subTitleLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
	}
}
