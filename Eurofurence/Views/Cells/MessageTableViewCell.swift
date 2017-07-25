//
//  MessageTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageAuthorLabel: UILabel!
    @IBOutlet weak var messageReceivedDateLabel: UILabel!
    @IBOutlet weak var messageSynopsisLabel: UILabel!
    private var presentedMessage: Message?

    override func prepareForReuse() {
        super.prepareForReuse()

        accessibilityLabel = nil
        messageAuthorLabel.text = nil
        messageReceivedDateLabel.text = nil
        messageSynopsisLabel.text = nil
    }

    func show(message: Message) {
        messageAuthorLabel.text = message.authorName

        accessibilityLabel = "Message from \(message.authorName)"
    }

}
