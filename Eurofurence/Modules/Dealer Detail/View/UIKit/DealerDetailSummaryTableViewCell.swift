//
//  DealerDetailSummaryTableViewCell.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 21/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit

class DealerDetailSummaryTableViewCell: UITableViewCell, DealerDetailSummaryComponent {

    // MARK: Properties

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var dealerTitleLabel: UILabel!
    @IBOutlet weak var dealerSubtitleLabel: UILabel!
    @IBOutlet weak var dealerCategoriesLabel: UILabel!
    @IBOutlet weak var dealerShortDescriptionLabel: UILabel!
    @IBOutlet weak var dealerWebsiteButton: UIButton!
    @IBOutlet weak var dealerWebsiteIconLabel: UILabel!
    @IBOutlet weak var dealerWebsiteContainer: UIView!
    @IBOutlet weak var twitterIconLabel: UILabel!
    @IBOutlet weak var dealerTwitterHandleButton: UIButton!
    @IBOutlet weak var dealerTwitterHandleContainer: UIView!
    @IBOutlet weak var dealerTelegramHandleButton: UIButton!
    @IBOutlet weak var dealerTelegramContainer: UIView!
    @IBOutlet weak var telegramIconLabel: UILabel!

    // MARK: Actions

    @IBAction func websiteButtonTapped(_ sender: Any) {
        websiteSelected?()
    }

    @IBAction func twitterButtonTapped(_ sender: Any) {
        twitterSelected?()
    }

    @IBAction func telegramButtonTapped(_ sender: Any) {
        telegramSelected?()
    }

    // MARK: Overrides

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .pantone330U

        let labelTextColor = UIColor.white
        dealerTitleLabel.textColor = labelTextColor
        dealerSubtitleLabel.textColor = labelTextColor
        dealerCategoriesLabel.textColor = labelTextColor
        dealerShortDescriptionLabel.textColor = labelTextColor
        twitterIconLabel.textColor = labelTextColor
        telegramIconLabel.textColor = labelTextColor
        dealerWebsiteIconLabel.textColor = labelTextColor
        dealerWebsiteButton.setTitleColor(labelTextColor, for: .normal)
        dealerTwitterHandleButton.setTitleColor(labelTextColor, for: .normal)
        dealerTelegramHandleButton.setTitleColor(labelTextColor, for: .normal)
    }

    // MARK: DealerDetailSummaryComponent

    func showArtistArtworkImageWithPNGData(_ data: Data) {
        let image = UIImage(data: data)
        artistImageView.image = image
        artistImageView.isHidden = false

        if let image = image {
            let size = image.size
            let aspectRatio = size.width / size.height
            artistImageView.widthAnchor.constraint(equalTo: artistImageView.heightAnchor, multiplier: aspectRatio).isActive = true
        }
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
        dealerWebsiteButton.setTitle(website, for: .normal)
        dealerWebsiteContainer.isHidden = false
    }

    func hideDealerWebsite() {
        dealerWebsiteContainer.isHidden = true
    }

    func showDealerTwitterHandle(_ twitterHandle: String) {
        dealerTwitterHandleButton.setTitle(twitterHandle, for: .normal)
        dealerTwitterHandleContainer.isHidden = false
    }

    func hideTwitterHandle() {
        dealerTwitterHandleContainer.isHidden = true
    }

    func showDealerTelegramHandle(_ telegramHandle: String) {
        dealerTelegramHandleButton.setTitle(telegramHandle, for: .normal)
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

}
