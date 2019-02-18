//
//  MessageTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 25/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UIKit

class MessageTableViewCell: UITableViewCell, MessageItemScene {

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
    private var presentedMessage: MessageEntity?

    override func prepareForReuse() {
        super.prepareForReuse()

        accessibilityLabel = nil
        messageAuthorLabel.text = nil
        messageSubjectLabel.text = nil
        messageReceivedDateLabel.text = nil
        messageSynopsisLabel.text = nil
    }

    func show(message: MessageEntity) {
        let receivedDateString = MessageTableViewCell.dateFormatter.string(from: message.receivedDateTime)
        messageAuthorLabel.text = message.authorName
        messageSubjectLabel.text = message.subject
        messageReceivedDateLabel.text = receivedDateString
        messageSynopsisLabel.text = message.contents
        unreadMessageIndicator.isHidden = message.isRead

        var messageOpening = "Message"
        if !message.isRead {
            messageOpening = "Unread message"
        }

        accessibilityLabel = "\(messageOpening) from \(message.authorName), \"\(message.subject)\". Received \(receivedDateString))."
    }

    func presentAuthor(_ author: String) {
        messageAuthorLabel.text = author
    }

    func presentSubject(_ subject: String) {
        messageSubjectLabel.text = subject
    }

    func presentContents(_ contents: String) {
        messageSynopsisLabel.text = contents
    }

    func presentReceivedDateTime(_ dateTime: String) {
        messageReceivedDateLabel.text = dateTime
    }

    func showUnreadIndicator() {
        unreadMessageIndicator.isHidden = false
    }

    func hideUnreadIndicator() {
        unreadMessageIndicator.isHidden = true
    }

}
