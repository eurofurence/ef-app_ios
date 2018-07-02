//
//  ViewAllAnnouncementsTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class ViewAllAnnouncementsTableViewCell: UITableViewCell, AllAnnouncementsComponent {

    // MARK: Properties

    @IBOutlet weak var allAnnouncementsCaptionLabel: UILabel!

    // MARK: AllAnnouncementsComponent

    func showCaption(_ caption: String) {
        allAnnouncementsCaptionLabel.text = caption
    }

}
