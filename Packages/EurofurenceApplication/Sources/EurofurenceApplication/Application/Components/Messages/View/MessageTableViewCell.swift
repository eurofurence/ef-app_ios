import ComponentBase
import EurofurenceModel
import UIKit

class MessageTableViewCell: UITableViewCell, MessageItemScene {

    private static var dateFormatter: DateFormatter = {
        let formatter = EurofurenceDateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .short

        return formatter
    }()

    @IBOutlet private weak var messageAuthorLabel: UILabel!
    @IBOutlet private weak var messageSubjectLabel: UILabel!
    @IBOutlet private weak var messageReceivedDateLabel: UILabel!
    @IBOutlet private weak var messageSynopsisLabel: UILabel!
    @IBOutlet private weak var unreadMessageIndicator: UIView!

    override func prepareForReuse() {
        super.prepareForReuse()

        accessibilityLabel = nil
        messageAuthorLabel.text = nil
        messageSubjectLabel.text = nil
        messageReceivedDateLabel.text = nil
        messageSynopsisLabel.text = nil
    }

    func setAuthor(_ author: String) {
        messageAuthorLabel.text = author
    }

    func setSubject(_ subject: String) {
        messageSubjectLabel.text = subject
    }

    func setContents(_ contents: NSAttributedString) {
        messageSynopsisLabel.attributedText = contents
    }

    func setReceivedDateTime(_ dateTime: String) {
        messageReceivedDateLabel.text = dateTime
    }

    func showUnreadIndicator() {
        unreadMessageIndicator.isHidden = false
    }

    func hideUnreadIndicator() {
        unreadMessageIndicator.isHidden = true
    }

}
