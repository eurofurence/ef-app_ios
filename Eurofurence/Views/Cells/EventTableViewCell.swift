//
//  EventTableViewCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventSubNameLabel: UILabel!
    @IBOutlet weak var eventDurationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventRoomLabel: UILabel!
    @IBOutlet weak var eventDayLabel: UILabel!
    @IBOutlet weak var eventDayLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventSubNameLabelHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
