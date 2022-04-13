import UIKit

class ViewAllAnnouncementsTableViewCell: UITableViewCell, AllAnnouncementsComponent {
    
    override class func registerNib(in tableView: UITableView) {
        registerNib(in: tableView, bundle: .module)
    }

    // MARK: Properties

    @IBOutlet private weak var allAnnouncementsCaptionLabel: UILabel! {
        didSet {
            allAnnouncementsCaptionLabel.accessibilityIdentifier = "ShowAllAnnouncements_Prompt"
        }
    }

    // MARK: AllAnnouncementsComponent

    func showCaption(_ caption: String) {
        allAnnouncementsCaptionLabel.text = caption
    }

}
