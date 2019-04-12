import UIKit

class DealerDetailSummaryTableViewCell: UITableViewCell, DealerDetailSummaryComponent {

    // MARK: Properties

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var dealerTitleLabel: UILabel!
    @IBOutlet weak var dealerSubtitleLabel: UILabel!
    @IBOutlet weak var dealerCategoriesLabel: UILabel!
    @IBOutlet weak var dealerShortDescriptionLabel: UILabel!
    @IBOutlet weak var dealerWebsiteLabel: UILabel!
    @IBOutlet weak var dealerWebsiteIconLabel: UILabel!
    @IBOutlet weak var dealerWebsiteContainer: UIView!
    @IBOutlet weak var twitterIconLabel: UILabel!
    @IBOutlet weak var dealerTwitterHandleLabel: UILabel!
    @IBOutlet weak var dealerTwitterHandleContainer: UIView!
    @IBOutlet weak var dealerTelegramHandleLabel: UILabel!
    @IBOutlet weak var dealerTelegramContainer: UIView!
    @IBOutlet weak var telegramIconLabel: UILabel!

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        isAccessibilityElement = false
        accessibilityElements = [
            dealerTitleLabel as Any,
            dealerSubtitleLabel as Any,
            dealerCategoriesLabel as Any,
            dealerShortDescriptionLabel as Any,
            dealerWebsiteContainer as Any,
            dealerTwitterHandleContainer as Any,
            dealerTelegramContainer as Any
        ]

        contentView.backgroundColor = .pantone330U

        let labelTextColor = UIColor.white
        dealerTitleLabel.textColor = labelTextColor
        dealerSubtitleLabel.textColor = labelTextColor
        dealerCategoriesLabel.textColor = labelTextColor
        dealerShortDescriptionLabel.textColor = labelTextColor
        twitterIconLabel.textColor = labelTextColor
        telegramIconLabel.textColor = labelTextColor
        dealerWebsiteIconLabel.textColor = labelTextColor
        dealerWebsiteLabel.textColor = labelTextColor
        dealerTwitterHandleLabel.textColor = labelTextColor
        dealerTelegramHandleLabel.textColor = labelTextColor

        let websiteTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(websiteTapped))
        dealerWebsiteContainer.addGestureRecognizer(websiteTappedRecognizer)

        let twitterTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(twitterTapped))
        dealerTwitterHandleContainer.addGestureRecognizer(twitterTappedRecognizer)

        let telegramTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(telegramTapped))
        dealerTelegramContainer.addGestureRecognizer(telegramTappedGestureRecognizer)
    }

    // MARK: DealerDetailSummaryComponent

    func showArtistArtworkImageWithPNGData(_ data: Data) {
        let image = UIImage(data: data)
        artistImageView.image = image
        artistImageView.isHidden = false
    }

    func hideArtistArtwork() {
        artistImageView.isHidden = true
    }

    func setDealerTitle(_ title: String) {
        dealerTitleLabel.text = title
        dealerTitleLabel.isHidden = false
    }

    func showDealerSubtitle(_ subtitle: String) {
        dealerSubtitleLabel.text = subtitle
        dealerSubtitleLabel.isHidden = false
    }

    func hideDealerSubtitle() {
        dealerSubtitleLabel.isHidden = true
    }

    func setDealerCategories(_ categories: String) {
        dealerCategoriesLabel.text = categories
    }

    func showDealerShortDescription(_ shortDescription: String) {
        dealerShortDescriptionLabel.text = shortDescription
        dealerShortDescriptionLabel.isHidden = false
    }

    func hideDealerShortDescription() {
        dealerShortDescriptionLabel.isHidden = true
    }

    func showDealerWebsite(_ website: String) {
        dealerWebsiteLabel.text = website
        dealerWebsiteContainer.isHidden = false
    }

    func hideDealerWebsite() {
        dealerWebsiteContainer.isHidden = true
    }

    func showDealerTwitterHandle(_ twitterHandle: String) {
        dealerTwitterHandleLabel.text = twitterHandle
        dealerTwitterHandleContainer.isHidden = false
    }

    func hideTwitterHandle() {
        dealerTwitterHandleContainer.isHidden = true
    }

    func showDealerTelegramHandle(_ telegramHandle: String) {
        dealerTelegramHandleLabel.text = telegramHandle
        dealerTelegramContainer.isHidden = false
    }

    func hideTelegramHandle() {
        dealerTelegramContainer.isHidden = true
    }

    private var websiteSelected: (() -> Void)?
    func onWebsiteSelected(perform block: @escaping () -> Void) {
        websiteSelected = block
    }

    private var twitterSelected: (() -> Void)?
    func onTwitterSelected(perform block: @escaping () -> Void) {
        twitterSelected = block
    }

    private var telegramSelected: (() -> Void)?
    func onTelegramSelected(perform block: @escaping () -> Void) {
        telegramSelected = block
    }

    // MARK: Private

    @objc private func websiteTapped(_ sender: Any) {
        websiteSelected?()
    }

    @objc private func twitterTapped(_ sender: Any) {
        twitterSelected?()
    }

    @objc private func telegramTapped(_ sender: Any) {
        telegramSelected?()
    }

}
