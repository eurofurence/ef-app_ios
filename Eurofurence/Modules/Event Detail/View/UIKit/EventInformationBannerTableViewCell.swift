import UIKit

class EventInformationBannerTableViewCell: UITableViewCell, EventInformationBannerComponent {

    // MARK: Properties

    @IBOutlet private weak var iconLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    // MARK: EventInformationBannerComponent

    func setBannerMessage(_ message: String) {
        messageLabel.text = message
    }
    
    // MARK: Functions
    
    func configureIcon(text: String, textColor: UIColor) {
        iconLabel.text = text
        iconLabel.textColor = textColor
    }

}
