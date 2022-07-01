import ComponentBase
import UIKit

class DealerComponentTableViewCell: UITableViewCell, DealerComponent {

    // MARK: Properties

    @IBOutlet private weak var dealerIconImageView: UIImageView!
    @IBOutlet private weak var dealerTitleLabel: UILabel!
    @IBOutlet private weak var dealerSubtitleLabel: UILabel!
    @IBOutlet private weak var notAvailableForEntireConferenceWarningView: IconView! {
        didSet {
            notAvailableForEntireConferenceWarningView.icon = .notAvailableForEntireConference
        }
    }
    
    @IBOutlet private weak var containsAfterDarkContentWarningView: IconView! {
        didSet {
            containsAfterDarkContentWarningView.icon = .afterDarkDealersDen
        }
    }

    // MARK: DealerComponent

    func setDealerTitle(_ title: String) {
        dealerTitleLabel.text = title
    }

    func setDealerSubtitle(_ subtitle: String?) {
        dealerSubtitleLabel.text = subtitle
    }

    func setDealerIconPNGData(_ pngData: Data) {
        dealerIconImageView.image = UIImage(data: pngData)
    }

    func showNotPresentOnAllDaysWarning() {
        notAvailableForEntireConferenceWarningView.isHidden = false
    }

    func hideNotPresentOnAllDaysWarning() {
        notAvailableForEntireConferenceWarningView.isHidden = true
    }

    func showAfterDarkContentWarning() {
        containsAfterDarkContentWarningView.isHidden = false
    }

    func hideAfterDarkContentWarning() {
        containsAfterDarkContentWarningView.isHidden = true
    }

}
