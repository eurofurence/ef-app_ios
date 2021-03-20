import UIKit

class ScheduleDayCollectionViewCell: UICollectionViewCell, ScheduleDayComponent {

    @IBOutlet private weak var selectedDecorationView: UIView!
    @IBOutlet private weak var dayTitleLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            updateSelectionStateAppearence()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateSelectionStateAppearence()
    }

    private func updateSelectionStateAppearence() {
        selectedDecorationView.alpha = isSelected ? 1 : 0

        let font: UIFont = {
            let size = UIFont.preferredFont(forTextStyle: .footnote).pointSize
            return isSelected ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
        }()

        dayTitleLabel.font = font
    }

    func setDayTitle(_ title: String) {
        let format = NSLocalizedString(
            "RestrictEventsToDateFormat",
            bundle: .module,
            comment: "Format string used to build up an accessibility hint for the days button in the Schedule tab"
        )
        
        dayTitleLabel.text = title
        dayTitleLabel.accessibilityHint = String.localizedStringWithFormat(format, title)
    }

}
