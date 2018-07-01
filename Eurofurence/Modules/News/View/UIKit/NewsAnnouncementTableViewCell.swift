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
    @IBOutlet weak var unreadIndicatorView: UIView!

    // MARK: NewsAnnouncementComponent

    func setAnnouncementTitle(_ title: String) {
        announcementTitleLabel.text = title
    }

    func setAnnouncementDetail(_ detail: String) {
        announcementDescriptionLabel.text = detail
    }

    func hideUnreadIndicator() {
        unreadIndicatorView.isHidden = true
    }

    func showUnreadIndicator() {
        unreadIndicatorView.isHidden = false
    }

}
