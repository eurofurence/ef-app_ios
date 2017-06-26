//
//  DealersTableViewCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class DealersTableViewCell: UITableViewCell {
    @IBOutlet weak var subnameDealerLabel: UILabel!
    @IBOutlet weak var artistDealerImage: UIImageView!
    @IBOutlet weak var displayNameDealerLabel: UILabel!
    @IBOutlet weak var shortDescriptionDealerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
