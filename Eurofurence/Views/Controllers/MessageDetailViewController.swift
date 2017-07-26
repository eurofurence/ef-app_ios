//
//  MessageDetailViewController.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 26/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

class MessageDetailViewController: UITableViewController {

    // MARK: IBOutlets

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    // MARK: Properties

    var message: Message?

    // MARK: Overrides

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        if let message = message {
            updateInterface(with: message)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row == 1 else { return UITableViewAutomaticDimension }
        guard let message = message else { return UITableViewAutomaticDimension }

        let availableWidth = messageLabel.frame.width
        let availableSize = CGSize(width: availableWidth, height: .greatestFiniteMagnitude)
        let font = messageLabel.font!
        let size = message.contents.boundingRect(with: availableSize,
                                                 options: .usesLineFragmentOrigin,
                                                 attributes: [NSFontAttributeName: font],
                                                 context: nil)

        let superHeight = super.tableView(tableView, heightForRowAt: indexPath)
        return max(superHeight, ceil(size.height) + (superHeight / 2))
    }

    // MARK: Private

    func updateInterface(with message: Message) {
        title = "\(message.authorName)"
        messageLabel.text = message.contents
    }

}
