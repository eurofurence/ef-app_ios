//
//  NewsEventTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class NewsAnnouncementTableViewCell: UITableViewCell, NewsAnnouncementComponent {

    // MARK: IBOutlets

    @IBOutlet weak var announcementTitleLabel: UILabel!
    @IBOutlet weak var announcementDescriptionLabel: UILabel!

    // MARK: NewsAnnouncementComponent

    func setAnnouncementTitle(_ title: String) {
        announcementTitleLabel.text = title
    }

    func setAnnouncementDetail(_ detail: String) {
        announcementDescriptionLabel.text = detail
    }

}
