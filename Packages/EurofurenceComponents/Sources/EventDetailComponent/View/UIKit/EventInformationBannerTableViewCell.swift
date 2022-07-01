import ComponentBase
import UIKit

class EventInformationBannerTableViewCell: UITableViewCell, EventInformationBannerComponent {

    // MARK: Properties

    @IBOutlet private weak var iconContainer: UIStackView!
    @IBOutlet private weak var messageLabel: UILabel!

    // MARK: EventInformationBannerComponent

    func setBannerMessage(_ message: String) {
        messageLabel.text = message
    }
    
    // MARK: Functions
    
    func configureIcons(icons: [IconView.Icon]) {
        for existingIcon in iconContainer.arrangedSubviews {
            existingIcon.removeFromSuperview()
        }
        
        let iconViews = icons.map(IconView.init(icon:))
        for iconView in iconViews {
            iconContainer.addArrangedSubview(iconView)
        }
    }

}
