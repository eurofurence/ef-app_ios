//
//  NewsEventTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 19/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell, AnnouncementComponent {

    // MARK: IBOutlets

    @IBOutlet weak var announcementReceivedDateTimeLabel: UILabel!
    @IBOutlet weak var announcementTitleLabel: UILabel!
    @IBOutlet weak var announcementDescriptionLabel: UILabel!
    @IBOutlet weak var unreadIndicatorView: UIView!

    // MARK: AnnouncementComponent

    func setAnnouncementTitle(_ title: String) {
        announcementTitleLabel.text = title
    }

    func setAnnouncementDetail(_ detail: String) {
        announcementDescriptionLabel.text = detail
    }

    func setAnnouncementReceivedDateTime(_ receivedDateTime: String) {
        announcementReceivedDateTimeLabel.text = receivedDateTime
    }

    func hideUnreadIndicator() {
        unreadIndicatorView.isHidden = true
    }

    func showUnreadIndicator() {
        unreadIndicatorView.isHidden = false
    }

}
