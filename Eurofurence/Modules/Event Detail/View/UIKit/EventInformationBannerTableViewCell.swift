//
//  EventInformationBannerTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 03/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class EventInformationBannerTableViewCell: UITableViewCell, EventInformationBannerComponent {

    // MARK: Properties

    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    // MARK: EventInformationBannerComponent

    func setBannerMessage(_ message: String) {
        messageLabel.text = message
    }

}
