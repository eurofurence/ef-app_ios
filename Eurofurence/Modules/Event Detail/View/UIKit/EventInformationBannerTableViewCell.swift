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
