//
//  MessageTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter
    }()

    @IBOutlet weak var messageAuthorLabel: UILabel!
    @IBOutlet weak var messageSubjectLabel: UILabel!
    @IBOutlet weak var messageReceivedDateLabel: UILabel!
    @IBOutlet weak var messageSynopsisLabel: UILabel!
    @IBOutlet weak var unreadMessageIndicator: UnreadMessageIndicator!
    private var presentedMessage: Message?

    override func prepareForReuse() {
        super.prepareForReuse()

        accessibilityLabel = nil
        messageAuthorLabel.text = nil
        messageSubjectLabel.text = nil
        messageReceivedDateLabel.text = nil
        messageSynopsisLabel.text = nil
    }

    func show(message: Message) {
        let receivedDateString = MessageTableViewCell.dateFormatter.string(from: message.receivedDateTime)
        messageAuthorLabel.text = message.authorName
        messageSubjectLabel.text = message.subject
        messageReceivedDateLabel.text = receivedDateString
        messageSynopsisLabel.text = message.contents
        unreadMessageIndicator.isHidden = message.isRead

        accessibilityLabel = "Message from \(message.authorName), \"\(message.subject)\". Received \(receivedDateString))."
    }

}
