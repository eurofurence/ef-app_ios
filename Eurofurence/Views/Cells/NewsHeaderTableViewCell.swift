//
//  NewsHeaderTableViewCell.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class NewsHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var newsHeaderLabel: UILabel!
    @IBOutlet weak var newsLastRefreshLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
