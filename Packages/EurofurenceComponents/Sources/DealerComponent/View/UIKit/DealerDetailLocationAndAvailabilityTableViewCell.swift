import ComponentBase
import UIKit

class DealerDetailLocationAndAvailabilityTableViewCell: UITableViewCell, DealerLocationAndAvailabilityComponent {

    // MARK: Properties

    @IBOutlet private weak var componentTitleLabel: UILabel!
    @IBOutlet private weak var dealerMapImageView: UIImageView!
    @IBOutlet private weak var limitedAvailabilityWarningContainer: UIStackView!
    @IBOutlet private weak var limitedAvailabilityWarningLabel: UILabel!
    @IBOutlet private weak var afterDarkInformationContainer: UIStackView!
    @IBOutlet private weak var afterDarkInformationLabel: UILabel!

    @IBOutlet private weak var limitedAvailabilityIcon: IconView! {
        didSet {
            limitedAvailabilityIcon.icon = .warning
        }
    }
      
    @IBOutlet private weak var afterDarkIcon: IconView! {
        didSet {
            afterDarkIcon.icon = .afterDarkDealersDen
        }
    }
    
    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        isAccessibilityElement = false
        accessibilityElements = [
            componentTitleLabel as Any,
            dealerMapImageView as Any,
            limitedAvailabilityWarningContainer as Any,
            afterDarkInformationContainer as Any
        ]

        dealerMapImageView.layer.borderColor = UIColor.lightGray.cgColor
        dealerMapImageView.layer.borderWidth = 1
        dealerMapImageView.contentMode = .scaleAspectFill
    }

    // MARK: DealerLocationAndAvailabilityComponent

    func setComponentTitle(_ title: String) {
        componentTitleLabel.text = title
    }

    func showMapPNGGraphicData(_ data: Data) {
        dealerMapImageView.image = UIImage(data: data)
        dealerMapImageView.isHidden = false
    }

    func showDealerLimitedAvailabilityWarning(_ warning: String) {
        limitedAvailabilityWarningLabel.text = warning
        limitedAvailabilityWarningContainer.isHidden = false
    }

    func showLocatedInAfterDarkDealersDenMessage(_ message: String) {
        afterDarkInformationLabel.text = message
        afterDarkInformationContainer.isHidden = false
    }

    func hideMap() {
        dealerMapImageView.isHidden = true
    }

    func hideLimitedAvailbilityWarning() {
        limitedAvailabilityWarningContainer.isHidden = true
    }

    func hideAfterDarkDenNotice() {
        afterDarkInformationContainer.isHidden = true
    }

}
