//
//  NewsConventionCountdownTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class NewsConventionCountdownTableViewCell: UITableViewCell, ConventionCountdownComponent {

    // MARK: IBOutlets

    @IBOutlet weak var timeUntilConventionLabel: UILabel!

    // MARK: ConventionCountdownComponent

    func setTimeUntilConvention(_ timeUntilConvention: String) {
        timeUntilConventionLabel.text = timeUntilConvention
    }

}
