import UIKit

class ViewAllAnnouncementsTableViewCell: UITableViewCell, AllAnnouncementsComponent {

    // MARK: Properties

    @IBOutlet weak var allAnnouncementsCaptionLabel: UILabel!

    // MARK: AllAnnouncementsComponent

    func showCaption(_ caption: String) {
        allAnnouncementsCaptionLabel.text = caption
    }

}
