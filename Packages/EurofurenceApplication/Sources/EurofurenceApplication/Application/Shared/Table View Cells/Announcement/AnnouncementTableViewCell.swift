import Combine
import UIKit

class AnnouncementTableViewCell: UITableViewCell, AnnouncementItemComponent {
    
    override class func registerNib(in tableView: UITableView) {
        registerNib(in: tableView, bundle: .module)
    }
    
    var subscriptions = Set<AnyCancellable>()

    // MARK: IBOutlets

    @IBOutlet private weak var announcementReceivedDateTimeLabel: UILabel!
    
    @IBOutlet private weak var announcementTitleLabel: UILabel! {
        didSet {
            announcementTitleLabel.accessibilityIdentifier = "Announcement_Title"
        }
    }
    
    @IBOutlet private weak var announcementDescriptionLabel: UILabel!
    
    @IBOutlet private weak var unreadIndicatorView: UIView! {
        didSet {
            unreadIndicatorView.accessibilityIdentifier = "Announcement_UnreadIndicator"
        }
    }

    // MARK: AnnouncementItemComponent

    func setAnnouncementTitle(_ title: String) {
        announcementTitleLabel.text = title
    }

    func setAnnouncementDetail(_ detail: NSAttributedString) {
        announcementDescriptionLabel.attributedText = detail
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
