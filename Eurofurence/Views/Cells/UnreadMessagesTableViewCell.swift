//
//  UnreadMessagesTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 20/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class UnreadMessagesTableViewCell: UITableViewCell {

    // MARK: IBOutlets

    @IBOutlet weak var usernameSynopsisLabel: UILabel!
    @IBOutlet weak var unreadMessageCountSynopsisLabel: UILabel!

    // MARK: Functions

    func showUserNameSynopsis(_ synopsis: String) {
        usernameSynopsisLabel.text = synopsis
    }

    func showUnreadMessageCountSynopsis(_ synopsis: String) {
        unreadMessageCountSynopsisLabel.text = synopsis
    }

}
